// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockMovementReportDataSourceHash() =>
    r'6d9ef81c8e0d86ab24a2f667e6fc997d2f9f3062';

/// See also [stockMovementReportDataSource].
@ProviderFor(stockMovementReportDataSource)
final stockMovementReportDataSourceProvider =
    AutoDisposeFutureProvider<StockMovementReportRemoteDataSource>.internal(
      stockMovementReportDataSource,
      name: r'stockMovementReportDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockMovementReportDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StockMovementReportDataSourceRef =
    AutoDisposeFutureProviderRef<StockMovementReportRemoteDataSource>;
String _$stockMovementReportRepositoryHash() =>
    r'2619f859af02a2d44e620fe48577cb4dce30dd6a';

/// See also [stockMovementReportRepository].
@ProviderFor(stockMovementReportRepository)
final stockMovementReportRepositoryProvider =
    AutoDisposeFutureProvider<StockMovementReportRepository>.internal(
      stockMovementReportRepository,
      name: r'stockMovementReportRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockMovementReportRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StockMovementReportRepositoryRef =
    AutoDisposeFutureProviderRef<StockMovementReportRepository>;
String _$stockMovementReportNotifierHash() =>
    r'e49142c04d139c2bb26c27f911a53e182a5c0823';

/// See also [StockMovementReportNotifier].
@ProviderFor(StockMovementReportNotifier)
final stockMovementReportNotifierProvider =
    AutoDisposeNotifierProvider<
      StockMovementReportNotifier,
      StockMovementReportState
    >.internal(
      StockMovementReportNotifier.new,
      name: r'stockMovementReportNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockMovementReportNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StockMovementReportNotifier =
    AutoDisposeNotifier<StockMovementReportState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
