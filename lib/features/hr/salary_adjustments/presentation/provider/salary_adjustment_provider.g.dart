// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_adjustment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adjustmentNotifierHash() =>
    r'ab1325ece60e55dee6e32b79f5f57682a91a6335';

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

abstract class _$AdjustmentNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<SalaryAdjustmentEntity>> {
  late final int salaryId;

  FutureOr<List<SalaryAdjustmentEntity>> build(int salaryId);
}

/// See also [AdjustmentNotifier].
@ProviderFor(AdjustmentNotifier)
const adjustmentNotifierProvider = AdjustmentNotifierFamily();

/// See also [AdjustmentNotifier].
class AdjustmentNotifierFamily
    extends Family<AsyncValue<List<SalaryAdjustmentEntity>>> {
  /// See also [AdjustmentNotifier].
  const AdjustmentNotifierFamily();

  /// See also [AdjustmentNotifier].
  AdjustmentNotifierProvider call(int salaryId) {
    return AdjustmentNotifierProvider(salaryId);
  }

  @override
  AdjustmentNotifierProvider getProviderOverride(
    covariant AdjustmentNotifierProvider provider,
  ) {
    return call(provider.salaryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adjustmentNotifierProvider';
}

/// See also [AdjustmentNotifier].
class AdjustmentNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          AdjustmentNotifier,
          List<SalaryAdjustmentEntity>
        > {
  /// See also [AdjustmentNotifier].
  AdjustmentNotifierProvider(int salaryId)
    : this._internal(
        () => AdjustmentNotifier()..salaryId = salaryId,
        from: adjustmentNotifierProvider,
        name: r'adjustmentNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$adjustmentNotifierHash,
        dependencies: AdjustmentNotifierFamily._dependencies,
        allTransitiveDependencies:
            AdjustmentNotifierFamily._allTransitiveDependencies,
        salaryId: salaryId,
      );

  AdjustmentNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.salaryId,
  }) : super.internal();

  final int salaryId;

  @override
  FutureOr<List<SalaryAdjustmentEntity>> runNotifierBuild(
    covariant AdjustmentNotifier notifier,
  ) {
    return notifier.build(salaryId);
  }

  @override
  Override overrideWith(AdjustmentNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AdjustmentNotifierProvider._internal(
        () => create()..salaryId = salaryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        salaryId: salaryId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    AdjustmentNotifier,
    List<SalaryAdjustmentEntity>
  >
  createElement() {
    return _AdjustmentNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdjustmentNotifierProvider && other.salaryId == salaryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, salaryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdjustmentNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<SalaryAdjustmentEntity>> {
  /// The parameter `salaryId` of this provider.
  int get salaryId;
}

class _AdjustmentNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          AdjustmentNotifier,
          List<SalaryAdjustmentEntity>
        >
    with AdjustmentNotifierRef {
  _AdjustmentNotifierProviderElement(super.provider);

  @override
  int get salaryId => (origin as AdjustmentNotifierProvider).salaryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
