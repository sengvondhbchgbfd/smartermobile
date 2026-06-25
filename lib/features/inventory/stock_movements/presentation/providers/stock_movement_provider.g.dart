// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockMovementDataSourceHash() =>
    r'3e685720667e7835b8a917f958e04395684891cf';

/// See also [stockMovementDataSource].
@ProviderFor(stockMovementDataSource)
final stockMovementDataSourceProvider =
    AutoDisposeFutureProvider<StockMovementRemoteDataSource>.internal(
      stockMovementDataSource,
      name: r'stockMovementDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockMovementDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StockMovementDataSourceRef =
    AutoDisposeFutureProviderRef<StockMovementRemoteDataSource>;
String _$stockMovementRepositoryHash() =>
    r'b8dc45f4661063b16533db5206f87c132360f816';

/// See also [stockMovementRepository].
@ProviderFor(stockMovementRepository)
final stockMovementRepositoryProvider =
    AutoDisposeFutureProvider<StockMovementRepository>.internal(
      stockMovementRepository,
      name: r'stockMovementRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockMovementRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StockMovementRepositoryRef =
    AutoDisposeFutureProviderRef<StockMovementRepository>;
String _$getAllStockMovementsUCHash() =>
    r'c06ca9232fe464b77a1f6d13c94d417c24864a39';

/// See also [getAllStockMovementsUC].
@ProviderFor(getAllStockMovementsUC)
final getAllStockMovementsUCProvider =
    AutoDisposeFutureProvider<GetAllStockMovementsUseCase>.internal(
      getAllStockMovementsUC,
      name: r'getAllStockMovementsUCProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getAllStockMovementsUCHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllStockMovementsUCRef =
    AutoDisposeFutureProviderRef<GetAllStockMovementsUseCase>;
String _$createStockMovementUCHash() =>
    r'04d0523023912adef84c2c1f750d1e166f52f663';

/// See also [createStockMovementUC].
@ProviderFor(createStockMovementUC)
final createStockMovementUCProvider =
    AutoDisposeFutureProvider<CreateStockMovementUseCase>.internal(
      createStockMovementUC,
      name: r'createStockMovementUCProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createStockMovementUCHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateStockMovementUCRef =
    AutoDisposeFutureProviderRef<CreateStockMovementUseCase>;
String _$deleteStockMovementUCHash() =>
    r'b3d2fe1fcf625a9c863879466bda631b959f4ee1';

/// See also [deleteStockMovementUC].
@ProviderFor(deleteStockMovementUC)
final deleteStockMovementUCProvider =
    AutoDisposeFutureProvider<DeleteStockMovementUseCase>.internal(
      deleteStockMovementUC,
      name: r'deleteStockMovementUCProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteStockMovementUCHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteStockMovementUCRef =
    AutoDisposeFutureProviderRef<DeleteStockMovementUseCase>;
String _$stockMovementNotifierHash() =>
    r'c11b5026dfca102e98fa08bd3f55e759a029b058';

/// See also [StockMovementNotifier].
@ProviderFor(StockMovementNotifier)
final stockMovementNotifierProvider =
    AutoDisposeNotifierProvider<
      StockMovementNotifier,
      StockMovementState
    >.internal(
      StockMovementNotifier.new,
      name: r'stockMovementNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockMovementNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StockMovementNotifier = AutoDisposeNotifier<StockMovementState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
