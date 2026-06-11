import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import '../models/notification_model.dart';
<<<<<<< HEAD

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getMyNotifications({bool unreadOnly = false});
  Future<NotificationSummaryModel> getSummary();
  Future<List<NotificationModel>> getAllNotifications({
    bool unreadOnly = false,
  });
  Future<NotificationModel> createNotification(Map<String, dynamic> body);
  Future<NotificationModel> markOneRead(int notificationId);
  Future<void> markAllRead();
  Future<void> bulkMarkRead(List<int> ids);
  Future<void> deleteOne(int notificationId);
  Future<void> deleteAllRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<dynamic> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    final response = await _dio.post(path, data: body);
    return response.data;
  }

  Future<dynamic> _patch(String path, [Map<String, dynamic>? body]) async {
    final response = await _dio.patch(path, data: body);
    return response.data;
  }

  Future<void> _delete(String path) async {
    await _dio.delete(path);
  }

  // ── API calls ─────────────────────────────────────────────────────────────

  @override
  Future<List<NotificationModel>> getMyNotifications({
    bool unreadOnly = false,
  }) async {
    final data = await _get(
      ApiEndpoints.notificationsMy,
      queryParameters: unreadOnly ? {'unread_only': true} : null,
    );
    return (data as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<NotificationSummaryModel> getSummary() async {
    final data = await _get(ApiEndpoints.notificationsMySummary);
    return NotificationSummaryModel.fromJson(data);
  }

  @override
  Future<List<NotificationModel>> getAllNotifications({
    bool unreadOnly = false,
  }) async {
    final data = await _get(
      ApiEndpoints.notifications,
      queryParameters: unreadOnly ? {'unread_only': true} : null,
    );
    return (data as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<NotificationModel> createNotification(
    Map<String, dynamic> body,
  ) async {
    final data = await _post(ApiEndpoints.notifications, body);
    return NotificationModel.fromJson(data);
  }

  @override
  Future<NotificationModel> markOneRead(int notificationId) async {
    final data = await _patch(
      ApiEndpoints.notificationMarkRead(notificationId),
    );
    return NotificationModel.fromJson(data);
  }

  @override
  Future<void> markAllRead() => _patch(ApiEndpoints.notificationsMyReadAll);

  @override
  Future<void> bulkMarkRead(List<int> ids) =>
      _patch(ApiEndpoints.notificationsMyBulkRead, {'notification_ids': ids});

  @override
  Future<void> deleteOne(int notificationId) =>
      _delete(ApiEndpoints.notificationById(notificationId));

  @override
  Future<void> deleteAllRead() => _delete(ApiEndpoints.notificationsClearRead);
}
