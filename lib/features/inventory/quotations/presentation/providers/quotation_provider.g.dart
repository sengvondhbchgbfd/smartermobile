// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotationRemoteDataSourceHash() =>
    r'34ac94feb1fcc6077954e9cf78b3dd5e6058f883';

/// See also [quotationRemoteDataSource].
@ProviderFor(quotationRemoteDataSource)
final quotationRemoteDataSourceProvider =
    AutoDisposeFutureProvider<QuotationRemoteDataSource>.internal(
      quotationRemoteDataSource,
      name: r'quotationRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quotationRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuotationRemoteDataSourceRef =
    AutoDisposeFutureProviderRef<QuotationRemoteDataSource>;
String _$quotationRepositoryHash() =>
    r'c0bdacc0e76b7b9266b95a43d916167723eaebab';

/// See also [quotationRepository].
@ProviderFor(quotationRepository)
final quotationRepositoryProvider =
    AutoDisposeFutureProvider<QuotationRepository>.internal(
      quotationRepository,
      name: r'quotationRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quotationRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuotationRepositoryRef =
    AutoDisposeFutureProviderRef<QuotationRepository>;
String _$quotationUsecaseHash() => r'a8d2a665ae0b69aaa27246ffa57e512898718ef1';

/// See also [quotationUsecase].
@ProviderFor(quotationUsecase)
final quotationUsecaseProvider =
    AutoDisposeFutureProvider<QuotationUsecase>.internal(
      quotationUsecase,
      name: r'quotationUsecaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quotationUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuotationUsecaseRef = AutoDisposeFutureProviderRef<QuotationUsecase>;
String _$quotationSummaryHash() => r'01422cc5436f9e37a984312567d4d7cb5da6d764';

/// See also [quotationSummary].
@ProviderFor(quotationSummary)
final quotationSummaryProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      quotationSummary,
      name: r'quotationSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quotationSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuotationSummaryRef =
    AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$quotationListNotifierHash() =>
    r'd228e52b11c1d2181f0f221b8af504bcd85d2b80';

/// See also [QuotationListNotifier].
@ProviderFor(QuotationListNotifier)
final quotationListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      QuotationListNotifier,
      List<QuotationEntity>
    >.internal(
      QuotationListNotifier.new,
      name: r'quotationListNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quotationListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuotationListNotifier =
    AutoDisposeAsyncNotifier<List<QuotationEntity>>;
String _$myQuotationsNotifierHash() =>
    r'620203e768722d2b7c8d322aa441d1e9764641f7';

/// See also [MyQuotationsNotifier].
@ProviderFor(MyQuotationsNotifier)
final myQuotationsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      MyQuotationsNotifier,
      List<QuotationEntity>
    >.internal(
      MyQuotationsNotifier.new,
      name: r'myQuotationsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myQuotationsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MyQuotationsNotifier =
    AutoDisposeAsyncNotifier<List<QuotationEntity>>;
String _$quotationDetailNotifierHash() =>
    r'13ebfebb1625af949306621e139661a4f795a1cd';

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

abstract class _$QuotationDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<QuotationEntity> {
  late final int quotationId;

  FutureOr<QuotationEntity> build(int quotationId);
}

/// See also [QuotationDetailNotifier].
@ProviderFor(QuotationDetailNotifier)
const quotationDetailNotifierProvider = QuotationDetailNotifierFamily();

/// See also [QuotationDetailNotifier].
class QuotationDetailNotifierFamily
    extends Family<AsyncValue<QuotationEntity>> {
  /// See also [QuotationDetailNotifier].
  const QuotationDetailNotifierFamily();

  /// See also [QuotationDetailNotifier].
  QuotationDetailNotifierProvider call(int quotationId) {
    return QuotationDetailNotifierProvider(quotationId);
  }

  @override
  QuotationDetailNotifierProvider getProviderOverride(
    covariant QuotationDetailNotifierProvider provider,
  ) {
    return call(provider.quotationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quotationDetailNotifierProvider';
}

/// See also [QuotationDetailNotifier].
class QuotationDetailNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          QuotationDetailNotifier,
          QuotationEntity
        > {
  /// See also [QuotationDetailNotifier].
  QuotationDetailNotifierProvider(int quotationId)
    : this._internal(
        () => QuotationDetailNotifier()..quotationId = quotationId,
        from: quotationDetailNotifierProvider,
        name: r'quotationDetailNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quotationDetailNotifierHash,
        dependencies: QuotationDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            QuotationDetailNotifierFamily._allTransitiveDependencies,
        quotationId: quotationId,
      );

  QuotationDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quotationId,
  }) : super.internal();

  final int quotationId;

  @override
  FutureOr<QuotationEntity> runNotifierBuild(
    covariant QuotationDetailNotifier notifier,
  ) {
    return notifier.build(quotationId);
  }

  @override
  Override overrideWith(QuotationDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuotationDetailNotifierProvider._internal(
        () => create()..quotationId = quotationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quotationId: quotationId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    QuotationDetailNotifier,
    QuotationEntity
  >
  createElement() {
    return _QuotationDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuotationDetailNotifierProvider &&
        other.quotationId == quotationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quotationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuotationDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<QuotationEntity> {
  /// The parameter `quotationId` of this provider.
  int get quotationId;
}

class _QuotationDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          QuotationDetailNotifier,
          QuotationEntity
        >
    with QuotationDetailNotifierRef {
  _QuotationDetailNotifierProviderElement(super.provider);

  @override
  int get quotationId =>
      (origin as QuotationDetailNotifierProvider).quotationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
