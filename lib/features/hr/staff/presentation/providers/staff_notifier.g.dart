// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$staffDetailHash() => r'a506cc00a7ab8601fc40541b6fb17324a405c10e';

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

/// See also [staffDetail].
@ProviderFor(staffDetail)
const staffDetailProvider = StaffDetailFamily();

/// See also [staffDetail].
class StaffDetailFamily extends Family<AsyncValue<StaffEntity>> {
  /// See also [staffDetail].
  const StaffDetailFamily();

  /// See also [staffDetail].
  StaffDetailProvider call(int id) {
    return StaffDetailProvider(id);
  }

  @override
  StaffDetailProvider getProviderOverride(
    covariant StaffDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'staffDetailProvider';
}

/// See also [staffDetail].
class StaffDetailProvider extends AutoDisposeFutureProvider<StaffEntity> {
  /// See also [staffDetail].
  StaffDetailProvider(int id)
    : this._internal(
        (ref) => staffDetail(ref as StaffDetailRef, id),
        from: staffDetailProvider,
        name: r'staffDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$staffDetailHash,
        dependencies: StaffDetailFamily._dependencies,
        allTransitiveDependencies: StaffDetailFamily._allTransitiveDependencies,
        id: id,
      );

  StaffDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<StaffEntity> Function(StaffDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StaffDetailProvider._internal(
        (ref) => create(ref as StaffDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<StaffEntity> createElement() {
    return _StaffDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StaffDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StaffDetailRef on AutoDisposeFutureProviderRef<StaffEntity> {
  /// The parameter `id` of this provider.
  int get id;
}

class _StaffDetailProviderElement
    extends AutoDisposeFutureProviderElement<StaffEntity>
    with StaffDetailRef {
  _StaffDetailProviderElement(super.provider);

  @override
  int get id => (origin as StaffDetailProvider).id;
}

String _$staffManagersHash() => r'8113a268a65291876f6e03c7b101eb14a468614b';

/// See also [staffManagers].
@ProviderFor(staffManagers)
final staffManagersProvider =
    AutoDisposeFutureProvider<List<StaffEntity>>.internal(
      staffManagers,
      name: r'staffManagersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$staffManagersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StaffManagersRef = AutoDisposeFutureProviderRef<List<StaffEntity>>;
String _$staffByRoleHash() => r'c06b8be1af26741bb8bfef67db0e1dcd01a2cacc';

/// See also [staffByRole].
@ProviderFor(staffByRole)
const staffByRoleProvider = StaffByRoleFamily();

/// See also [staffByRole].
class StaffByRoleFamily extends Family<AsyncValue<List<StaffEntity>>> {
  /// See also [staffByRole].
  const StaffByRoleFamily();

  /// See also [staffByRole].
  StaffByRoleProvider call(int roleId) {
    return StaffByRoleProvider(roleId);
  }

  @override
  StaffByRoleProvider getProviderOverride(
    covariant StaffByRoleProvider provider,
  ) {
    return call(provider.roleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'staffByRoleProvider';
}

/// See also [staffByRole].
class StaffByRoleProvider extends AutoDisposeFutureProvider<List<StaffEntity>> {
  /// See also [staffByRole].
  StaffByRoleProvider(int roleId)
    : this._internal(
        (ref) => staffByRole(ref as StaffByRoleRef, roleId),
        from: staffByRoleProvider,
        name: r'staffByRoleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$staffByRoleHash,
        dependencies: StaffByRoleFamily._dependencies,
        allTransitiveDependencies: StaffByRoleFamily._allTransitiveDependencies,
        roleId: roleId,
      );

  StaffByRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roleId,
  }) : super.internal();

  final int roleId;

  @override
  Override overrideWith(
    FutureOr<List<StaffEntity>> Function(StaffByRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StaffByRoleProvider._internal(
        (ref) => create(ref as StaffByRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roleId: roleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StaffEntity>> createElement() {
    return _StaffByRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StaffByRoleProvider && other.roleId == roleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StaffByRoleRef on AutoDisposeFutureProviderRef<List<StaffEntity>> {
  /// The parameter `roleId` of this provider.
  int get roleId;
}

class _StaffByRoleProviderElement
    extends AutoDisposeFutureProviderElement<List<StaffEntity>>
    with StaffByRoleRef {
  _StaffByRoleProviderElement(super.provider);

  @override
  int get roleId => (origin as StaffByRoleProvider).roleId;
}

String _$staffByDepartmentHash() => r'00296962a75586fec563d5148c688767dda8a449';

/// See also [staffByDepartment].
@ProviderFor(staffByDepartment)
const staffByDepartmentProvider = StaffByDepartmentFamily();

/// See also [staffByDepartment].
class StaffByDepartmentFamily extends Family<AsyncValue<List<StaffEntity>>> {
  /// See also [staffByDepartment].
  const StaffByDepartmentFamily();

  /// See also [staffByDepartment].
  StaffByDepartmentProvider call(int deptId) {
    return StaffByDepartmentProvider(deptId);
  }

  @override
  StaffByDepartmentProvider getProviderOverride(
    covariant StaffByDepartmentProvider provider,
  ) {
    return call(provider.deptId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'staffByDepartmentProvider';
}

/// See also [staffByDepartment].
class StaffByDepartmentProvider
    extends AutoDisposeFutureProvider<List<StaffEntity>> {
  /// See also [staffByDepartment].
  StaffByDepartmentProvider(int deptId)
    : this._internal(
        (ref) => staffByDepartment(ref as StaffByDepartmentRef, deptId),
        from: staffByDepartmentProvider,
        name: r'staffByDepartmentProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$staffByDepartmentHash,
        dependencies: StaffByDepartmentFamily._dependencies,
        allTransitiveDependencies:
            StaffByDepartmentFamily._allTransitiveDependencies,
        deptId: deptId,
      );

  StaffByDepartmentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deptId,
  }) : super.internal();

  final int deptId;

  @override
  Override overrideWith(
    FutureOr<List<StaffEntity>> Function(StaffByDepartmentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StaffByDepartmentProvider._internal(
        (ref) => create(ref as StaffByDepartmentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deptId: deptId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StaffEntity>> createElement() {
    return _StaffByDepartmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StaffByDepartmentProvider && other.deptId == deptId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deptId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StaffByDepartmentRef on AutoDisposeFutureProviderRef<List<StaffEntity>> {
  /// The parameter `deptId` of this provider.
  int get deptId;
}

class _StaffByDepartmentProviderElement
    extends AutoDisposeFutureProviderElement<List<StaffEntity>>
    with StaffByDepartmentRef {
  _StaffByDepartmentProviderElement(super.provider);

  @override
  int get deptId => (origin as StaffByDepartmentProvider).deptId;
}

String _$staffNotifierHash() => r'507fb909c596d5ac759411eca61e6f1c0c3989d8';

/// See also [StaffNotifier].
@ProviderFor(StaffNotifier)
final staffNotifierProvider =
    AutoDisposeAsyncNotifierProvider<StaffNotifier, List<StaffEntity>>.internal(
      StaffNotifier.new,
      name: r'staffNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$staffNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StaffNotifier = AutoDisposeAsyncNotifier<List<StaffEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
