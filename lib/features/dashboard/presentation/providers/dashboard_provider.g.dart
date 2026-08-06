// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardRemoteDatasourceHash() =>
    r'2cf966c6559362a804e21cd9b722740fcb2aed3e';

/// See also [dashboardRemoteDatasource].
@ProviderFor(dashboardRemoteDatasource)
final dashboardRemoteDatasourceProvider =
    AutoDisposeFutureProvider<DashboardRemoteDatasource>.internal(
      dashboardRemoteDatasource,
      name: r'dashboardRemoteDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardRemoteDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRemoteDatasourceRef =
    AutoDisposeFutureProviderRef<DashboardRemoteDatasource>;
String _$dashboardRepositoryHash() =>
    r'3abdd6347e6200ae03447d8644c467649180e36c';

/// See also [dashboardRepository].
@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider =
    AutoDisposeFutureProvider<DashboardRepository>.internal(
      dashboardRepository,
      name: r'dashboardRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRepositoryRef =
    AutoDisposeFutureProviderRef<DashboardRepository>;
String _$dashboardStatsNotifierHash() =>
    r'365a6e5bbdbb5e8e18e2f36935ab86e933da013a';

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

abstract class _$DashboardStatsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<DashboardStats> {
  late final int days;

  FutureOr<DashboardStats> build({int days = 11});
}

/// See also [DashboardStatsNotifier].
@ProviderFor(DashboardStatsNotifier)
const dashboardStatsNotifierProvider = DashboardStatsNotifierFamily();

/// See also [DashboardStatsNotifier].
class DashboardStatsNotifierFamily extends Family<AsyncValue<DashboardStats>> {
  /// See also [DashboardStatsNotifier].
  const DashboardStatsNotifierFamily();

  /// See also [DashboardStatsNotifier].
  DashboardStatsNotifierProvider call({int days = 11}) {
    return DashboardStatsNotifierProvider(days: days);
  }

  @override
  DashboardStatsNotifierProvider getProviderOverride(
    covariant DashboardStatsNotifierProvider provider,
  ) {
    return call(days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardStatsNotifierProvider';
}

/// See also [DashboardStatsNotifier].
class DashboardStatsNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          DashboardStatsNotifier,
          DashboardStats
        > {
  /// See also [DashboardStatsNotifier].
  DashboardStatsNotifierProvider({int days = 11})
    : this._internal(
        () => DashboardStatsNotifier()..days = days,
        from: dashboardStatsNotifierProvider,
        name: r'dashboardStatsNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dashboardStatsNotifierHash,
        dependencies: DashboardStatsNotifierFamily._dependencies,
        allTransitiveDependencies:
            DashboardStatsNotifierFamily._allTransitiveDependencies,
        days: days,
      );

  DashboardStatsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  FutureOr<DashboardStats> runNotifierBuild(
    covariant DashboardStatsNotifier notifier,
  ) {
    return notifier.build(days: days);
  }

  @override
  Override overrideWith(DashboardStatsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DashboardStatsNotifierProvider._internal(
        () => create()..days = days,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    DashboardStatsNotifier,
    DashboardStats
  >
  createElement() {
    return _DashboardStatsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardStatsNotifierProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardStatsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<DashboardStats> {
  /// The parameter `days` of this provider.
  int get days;
}

class _DashboardStatsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          DashboardStatsNotifier,
          DashboardStats
        >
    with DashboardStatsNotifierRef {
  _DashboardStatsNotifierProviderElement(super.provider);

  @override
  int get days => (origin as DashboardStatsNotifierProvider).days;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
