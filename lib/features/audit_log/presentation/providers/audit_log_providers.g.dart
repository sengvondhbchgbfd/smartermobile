// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$auditLogDataSourceHash() =>
    r'e9debfddb9325feb73dddc99973efc81b70842d3';

/// See also [auditLogDataSource].
@ProviderFor(auditLogDataSource)
final auditLogDataSourceProvider =
    AutoDisposeFutureProvider<AuditLogRemoteDataSource>.internal(
      auditLogDataSource,
      name: r'auditLogDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$auditLogDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuditLogDataSourceRef =
    AutoDisposeFutureProviderRef<AuditLogRemoteDataSource>;
String _$auditLogRepositoryHash() =>
    r'13492de16eb55727398351044d89ada9eb2b23b0';

/// See also [auditLogRepository].
@ProviderFor(auditLogRepository)
final auditLogRepositoryProvider =
    AutoDisposeFutureProvider<AuditLogRepositoryImpl>.internal(
      auditLogRepository,
      name: r'auditLogRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$auditLogRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuditLogRepositoryRef =
    AutoDisposeFutureProviderRef<AuditLogRepositoryImpl>;
String _$auditLogListHash() => r'3b7117339068737fcaaee2928d654dd8d5265f2f';

/// See also [auditLogList].
@ProviderFor(auditLogList)
final auditLogListProvider =
    AutoDisposeFutureProvider<List<AuditLogEntity>>.internal(
      auditLogList,
      name: r'auditLogListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$auditLogListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuditLogListRef = AutoDisposeFutureProviderRef<List<AuditLogEntity>>;
String _$auditLogDetailHash() => r'c736242dfcfa9b78d40573d89e085d0c848f3ede';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [auditLogDetail].
@ProviderFor(auditLogDetail)
const auditLogDetailProvider = AuditLogDetailFamily();

/// See also [auditLogDetail].
class AuditLogDetailFamily extends Family<AsyncValue<AuditLogEntity>> {
  /// See also [auditLogDetail].
  const AuditLogDetailFamily();

  /// See also [auditLogDetail].
  AuditLogDetailProvider call(int logId) {
    return AuditLogDetailProvider(logId);
  }

  @override
  AuditLogDetailProvider getProviderOverride(
    covariant AuditLogDetailProvider provider,
  ) {
    return call(provider.logId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'auditLogDetailProvider';
}

/// See also [auditLogDetail].
class AuditLogDetailProvider extends AutoDisposeFutureProvider<AuditLogEntity> {
  /// See also [auditLogDetail].
  AuditLogDetailProvider(int logId)
    : this._internal(
        (ref) => auditLogDetail(ref as AuditLogDetailRef, logId),
        from: auditLogDetailProvider,
        name: r'auditLogDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$auditLogDetailHash,
        dependencies: AuditLogDetailFamily._dependencies,
        allTransitiveDependencies:
            AuditLogDetailFamily._allTransitiveDependencies,
        logId: logId,
      );

  AuditLogDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.logId,
  }) : super.internal();

  final int logId;

  @override
  Override overrideWith(
    FutureOr<AuditLogEntity> Function(AuditLogDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogDetailProvider._internal(
        (ref) => create(ref as AuditLogDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        logId: logId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AuditLogEntity> createElement() {
    return _AuditLogDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogDetailProvider && other.logId == logId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, logId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuditLogDetailRef on AutoDisposeFutureProviderRef<AuditLogEntity> {
  /// The parameter `logId` of this provider.
  int get logId;
}

class _AuditLogDetailProviderElement
    extends AutoDisposeFutureProviderElement<AuditLogEntity>
    with AuditLogDetailRef {
  _AuditLogDetailProviderElement(super.provider);

  @override
  int get logId => (origin as AuditLogDetailProvider).logId;
}

String _$auditLogsByUserHash() => r'4d243edc23aa437cf61da7749bceb22fdb364619';

/// See also [auditLogsByUser].
@ProviderFor(auditLogsByUser)
const auditLogsByUserProvider = AuditLogsByUserFamily();

/// See also [auditLogsByUser].
class AuditLogsByUserFamily extends Family<AsyncValue<List<AuditLogEntity>>> {
  /// See also [auditLogsByUser].
  const AuditLogsByUserFamily();

  /// See also [auditLogsByUser].
  AuditLogsByUserProvider call(int userId) {
    return AuditLogsByUserProvider(userId);
  }

  @override
  AuditLogsByUserProvider getProviderOverride(
    covariant AuditLogsByUserProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'auditLogsByUserProvider';
}

/// See also [auditLogsByUser].
class AuditLogsByUserProvider
    extends AutoDisposeFutureProvider<List<AuditLogEntity>> {
  /// See also [auditLogsByUser].
  AuditLogsByUserProvider(int userId)
    : this._internal(
        (ref) => auditLogsByUser(ref as AuditLogsByUserRef, userId),
        from: auditLogsByUserProvider,
        name: r'auditLogsByUserProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$auditLogsByUserHash,
        dependencies: AuditLogsByUserFamily._dependencies,
        allTransitiveDependencies:
            AuditLogsByUserFamily._allTransitiveDependencies,
        userId: userId,
      );

  AuditLogsByUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<List<AuditLogEntity>> Function(AuditLogsByUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogsByUserProvider._internal(
        (ref) => create(ref as AuditLogsByUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AuditLogEntity>> createElement() {
    return _AuditLogsByUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsByUserProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuditLogsByUserRef on AutoDisposeFutureProviderRef<List<AuditLogEntity>> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _AuditLogsByUserProviderElement
    extends AutoDisposeFutureProviderElement<List<AuditLogEntity>>
    with AuditLogsByUserRef {
  _AuditLogsByUserProviderElement(super.provider);

  @override
  int get userId => (origin as AuditLogsByUserProvider).userId;
}

String _$auditLogFilterNotifierHash() =>
    r'c184e147e38c3c4f0d234045306b8b0adee307b2';

/// See also [AuditLogFilterNotifier].
@ProviderFor(AuditLogFilterNotifier)
final auditLogFilterNotifierProvider =
    AutoDisposeNotifierProvider<
      AuditLogFilterNotifier,
      AuditLogFilter
    >.internal(
      AuditLogFilterNotifier.new,
      name: r'auditLogFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$auditLogFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuditLogFilterNotifier = AutoDisposeNotifier<AuditLogFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
