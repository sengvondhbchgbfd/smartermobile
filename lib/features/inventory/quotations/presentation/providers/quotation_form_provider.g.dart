// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotationFormNotifierHash() =>
    r'3d2fce4e5683cd9c203c1286cc9d772e95c7d6be';

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

abstract class _$QuotationFormNotifier
    extends BuildlessAutoDisposeNotifier<QuotationFormData> {
  late final QuotationEntity? initial;

  QuotationFormData build({QuotationEntity? initial});
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
///
/// Copied from [QuotationFormNotifier].
@ProviderFor(QuotationFormNotifier)
const quotationFormNotifierProvider = QuotationFormNotifierFamily();

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
///
/// Copied from [QuotationFormNotifier].
class QuotationFormNotifierFamily extends Family<QuotationFormData> {
  ////////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////////
  ///
  /// Copied from [QuotationFormNotifier].
  const QuotationFormNotifierFamily();

  ////////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////////
  ///
  /// Copied from [QuotationFormNotifier].
  QuotationFormNotifierProvider call({QuotationEntity? initial}) {
    return QuotationFormNotifierProvider(initial: initial);
  }

  @override
  QuotationFormNotifierProvider getProviderOverride(
    covariant QuotationFormNotifierProvider provider,
  ) {
    return call(initial: provider.initial);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quotationFormNotifierProvider';
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
///
/// Copied from [QuotationFormNotifier].
class QuotationFormNotifierProvider
    extends
        AutoDisposeNotifierProviderImpl<
          QuotationFormNotifier,
          QuotationFormData
        > {
  ////////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////////
  ///
  /// Copied from [QuotationFormNotifier].
  QuotationFormNotifierProvider({QuotationEntity? initial})
    : this._internal(
        () => QuotationFormNotifier()..initial = initial,
        from: quotationFormNotifierProvider,
        name: r'quotationFormNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quotationFormNotifierHash,
        dependencies: QuotationFormNotifierFamily._dependencies,
        allTransitiveDependencies:
            QuotationFormNotifierFamily._allTransitiveDependencies,
        initial: initial,
      );

  QuotationFormNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initial,
  }) : super.internal();

  final QuotationEntity? initial;

  @override
  QuotationFormData runNotifierBuild(covariant QuotationFormNotifier notifier) {
    return notifier.build(initial: initial);
  }

  @override
  Override overrideWith(QuotationFormNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuotationFormNotifierProvider._internal(
        () => create()..initial = initial,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initial: initial,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<QuotationFormNotifier, QuotationFormData>
  createElement() {
    return _QuotationFormNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuotationFormNotifierProvider && other.initial == initial;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initial.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuotationFormNotifierRef
    on AutoDisposeNotifierProviderRef<QuotationFormData> {
  /// The parameter `initial` of this provider.
  QuotationEntity? get initial;
}

class _QuotationFormNotifierProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          QuotationFormNotifier,
          QuotationFormData
        >
    with QuotationFormNotifierRef {
  _QuotationFormNotifierProviderElement(super.provider);

  @override
  QuotationEntity? get initial =>
      (origin as QuotationFormNotifierProvider).initial;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
