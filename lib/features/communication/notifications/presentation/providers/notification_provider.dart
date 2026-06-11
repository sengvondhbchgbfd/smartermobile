import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/constants/api_constants.dart';
import 'package:frontendmobile/features/communication/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:frontendmobile/features/communication/notifications/data/datasources/notification_ws_datasource.dart';
import 'package:frontendmobile/features/communication/notifications/data/repositories/notification_repository_impl.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';
import 'package:frontendmobile/features/communication/notifications/domain/repositories/notification_repository.dart';
import 'package:frontendmobile/features/communication/notifications/domain/usecase/notification_usecases.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
// ── Notifier ───────────────────────────────────────────────────────────────

class NotificationNotifier extends AsyncNotifier<NotificationState> {
  late final NotificationRemoteDataSourceImpl _remote;
  late final NotificationWsDataSource _ws;
  late final NotificationRepository _repo;

  // ── Use cases ──────────────────────────────────────────────────────────────

  late final GetMyNotificationsUseCase _getMyNotifications;
  late final GetSummaryUseCase _getSummary;
  late final GetAllNotificationsUseCase _getAllNotifications;
  late final CreateNotificationUseCase _createNotification;
  late final MarkOneReadUseCase _markOneRead;
  late final MarkAllReadUseCase _markAllRead;
  late final BulkMarkReadUseCase _bulkMarkRead;
  late final DeleteOneUseCase _deleteOne;
  late final DeleteAllReadUseCase _deleteAllRead;
  StreamSubscription<WsEvent>? _wsSub;

  @override
  Future<NotificationState> build() async {
    final dioClient = await ref.watch(dioClientProvider.future);
    final storage = ref.read(secureStorageProvider);

    _remote = NotificationRemoteDataSourceImpl(dio: dioClient.dio);
    _ws = NotificationWsDataSource(
      wsBaseUrl: ApiConstants.wsBaseUrl,
      getToken: storage.getAccessToken,
    );
    _repo = NotificationRepositoryImpl(_remote);

    _getMyNotifications = GetMyNotificationsUseCase(_repo);
    _getSummary = GetSummaryUseCase(_repo);
    _getAllNotifications = GetAllNotificationsUseCase(_repo);
    _createNotification = CreateNotificationUseCase(_repo);
    _markOneRead = MarkOneReadUseCase(_repo);
    _markAllRead = MarkAllReadUseCase(_repo);
    _bulkMarkRead = BulkMarkReadUseCase(_repo);
    _deleteOne = DeleteOneUseCase(_repo);
    _deleteAllRead = DeleteAllReadUseCase(_repo);

    _subscribeWs();

    ref.onDispose(() {
      _wsSub?.cancel();
      _ws.dispose();
    });

    return const NotificationState();
  }

  // ── WebSocket ──────────────────────────────────────────────────────────────

  void _subscribeWs() {
    _wsSub = _ws.events.listen((event) {
      final current = state.valueOrNull;
      if (current == null) return;
      switch (event) {
        case WsConnectedEvent():
          state = AsyncData(current.copyWith(wsConnected: true));
        case WsNewNotificationEvent(:final notification):
          final updated = [notification, ...current.notifications];
          final summary = current.summary != null
              ? NotificationSummaryEntity(
                  total: current.summary!.total + 1,
                  unread: current.summary!.unread + 1,
                  read: current.summary!.read,
                )
              : null;
          state = AsyncData(
            current.copyWith(notifications: updated, summary: summary),
          );
        case WsErrorEvent():
          state = AsyncData(current.copyWith(wsConnected: false));
        case WsPongEvent():
          break;
      }
    });
    _ws.connect();
  }

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadMyNotifications() async {
    final current = state.valueOrNull ?? const NotificationState();
    state = const AsyncLoading();
    try {
      final notifications = await _getMyNotifications(
        unreadOnly: current.filter == NotificationFilter.unread,
      );
      final summary = await _getSummary();
      state = AsyncData(
        current.copyWith(notifications: notifications, summary: summary),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  Future<void> loadAllNotifications({bool unreadOnly = false}) async {
    final current = state.valueOrNull ?? const NotificationState();
    state = const AsyncLoading();
    try {
      final notifications = await _getAllNotifications(unreadOnly: unreadOnly);
      state = AsyncData(current.copyWith(notifications: notifications));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ── Filter ─────────────────────────────────────────────────────────────────

  void setFilter(NotificationFilter f) {
    final current = state.valueOrNull;
    if (current == null || current.filter == f) return;
    state = AsyncData(current.copyWith(filter: f));
    loadMyNotifications();
  }

  // ── Mark read ──────────────────────────────────────────────────────────────

  Future<void> markOneRead(int notificationId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final idx = current.notifications.indexWhere(
      (n) => n.notificationId == notificationId,
    );
    if (idx == -1 || current.notifications[idx].isRead) return;

    final old = current.notifications[idx];
    final updated = [...current.notifications];
    updated[idx] = old.copyWith(isRead: true);
    state = AsyncData(current.copyWith(notifications: updated));
    _decrementUnread();

    try {
      await _markOneRead(notificationId);
    } catch (_) {
      final rollback = List<NotificationEntity>.from(
        state.valueOrNull?.notifications ?? [],
      );
      rollback[idx] = old;
      state = AsyncData(current.copyWith(notifications: rollback));
      _incrementUnread();
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////

  Future<void> markAllRead() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final prev = current.notifications;

    state = AsyncData(
      current.copyWith(
        notifications: prev.map((n) => n.copyWith(isRead: true)).toList(),
        summary: current.summary != null
            ? NotificationSummaryEntity(
                total: current.summary!.total,
                unread: 0,
                read: current.summary!.total,
              )
            : null,
      ),
    );

    try {
      await _markAllRead();
    } catch (_) {
      state = AsyncData(current.copyWith(notifications: prev));
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////

  Future<void> bulkMarkRead() async {
    final current = state.valueOrNull;
    if (current == null || current.selectedIds.isEmpty) return;
    final ids = current.selectedIds;
    final prev = current.notifications;

    state = AsyncData(
      current.copyWith(
        notifications: prev
            .map(
              (n) =>
                  ids.contains(n.notificationId) ? n.copyWith(isRead: true) : n,
            )
            .toList(),
      ),
    );
    try {
      await _bulkMarkRead(ids.toList());
      clearSelection();
    } catch (_) {
      state = AsyncData(current.copyWith(notifications: prev));
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<void> deleteOne(int notificationId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final idx = current.notifications.indexWhere(
      (n) => n.notificationId == notificationId,
    );
    if (idx == -1) return;

    final removed = current.notifications[idx];
    final updated = [...current.notifications]..removeAt(idx);
    state = AsyncData(current.copyWith(notifications: updated));
    if (!removed.isRead) _decrementUnread();

    try {
      await _deleteOne(notificationId);
    } catch (_) {
      final rollback = [...updated]..insert(idx, removed);
      state = AsyncData(current.copyWith(notifications: rollback));
      if (!removed.isRead) _incrementUnread();
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  Future<void> deleteAllRead() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final prev = current.notifications;
    final updated = prev.where((n) => !n.isRead).toList();
    state = AsyncData(current.copyWith(notifications: updated));

    try {
      await _deleteAllRead();
      final s = current.summary;
      if (s != null) {
        state = AsyncData(
          (state.valueOrNull ?? current).copyWith(
            summary: NotificationSummaryEntity(
              total: updated.length,
              unread: s.unread,
              read: 0,
            ),
          ),
        );
      }
    } catch (_) {
      state = AsyncData(current.copyWith(notifications: prev));
    }
  }

  // ── Admin create ───────────────────────────────────────────────────────────

  Future<void> adminCreate({
    required int userId,
    required String title,
    required String message,
    required String type,
    int? referenceId,
    String? referenceType,
  }) async {
    try {
      await _createNotification(
        userId: userId,
        title: title,
        message: message,
        type: type,
        referenceId: referenceId,
        referenceType: referenceType,
      );
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // ── Selection ──────────────────────────────────────────────────────────────

  void toggleSelectionMode() {
    final current = state.valueOrNull;
    if (current == null) return;
    final next = !current.isSelecting;
    state = AsyncData(
      current.copyWith(
        isSelecting: next,
        selectedIds: next ? current.selectedIds : {},
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  void toggleSelect(int id) {
    final current = state.valueOrNull;
    if (current == null) return;
    final ids = {...current.selectedIds};
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    state = AsyncData(current.copyWith(selectedIds: ids));
  }
  ///////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  void selectAll() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        selectedIds: current.notifications.map((n) => n.notificationId).toSet(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////
  void clearSelection() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedIds: {}, isSelecting: false));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _decrementUnread() {
    final current = state.valueOrNull;
    if (current?.summary == null) return;
    final u = (current!.summary!.unread - 1).clamp(0, current.summary!.total);
    state = AsyncData(
      current.copyWith(
        summary: NotificationSummaryEntity(
          total: current.summary!.total,
          unread: u,
          read: current.summary!.total - u,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  void _incrementUnread() {
    final current = state.valueOrNull;
    if (current?.summary == null) return;
    final u = current!.summary!.unread + 1;
    state = AsyncData(
      current.copyWith(
        summary: NotificationSummaryEntity(
          total: current.summary!.total,
          unread: u,
          read: current.summary!.total - u,
        ),
      ),
    );
  }
}

// ── Provider ───────────────────────────────────────────────────────────────

final notificationNotifierProvider =
    AsyncNotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );
