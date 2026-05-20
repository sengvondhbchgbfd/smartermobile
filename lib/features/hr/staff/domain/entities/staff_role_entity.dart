class StaffRoleEntity {
  final int? id;
  final int companyId;
  final String roleName;
  final String description;
  final double baseSalary;
  final bool isManager;
  final DateTime? createdAt;

  const StaffRoleEntity({
    this.id,
    required this.companyId,
    required this.roleName,
    required this.description,
    required this.baseSalary,
    required this.isManager,
    this.createdAt,
  });

  StaffRoleEntity copyWith({
    int? id,
    int? companyId,
    String? roleName,
    String? description,
    double? baseSalary,
    bool? isManager,
    DateTime? createdAt,
  }) {
    return StaffRoleEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      roleName: roleName ?? this.roleName,
      description: description ?? this.description,
      baseSalary: baseSalary ?? this.baseSalary,
      isManager: isManager ?? this.isManager,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}