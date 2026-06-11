class CreateStaffRequest {
  final int? userId;
  final int? staffRoleId;
  final String name;
  final String? gender;      // ✅ optional
  final String? dateOfBirth; // ✅ optional
  final String? address;     // ✅ optional
  final String? email;       // ✅ optional
  final String? phone;       // ✅ optional

  const CreateStaffRequest({
    this.userId,
    this.staffRoleId,
    required this.name,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.email,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
    if (userId != null)      'user_id':       userId,
    if (staffRoleId != null) 'staff_role_id': staffRoleId,
                             'name':          name,
    if (gender != null)      'gender':        gender,
    if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
    if (address != null)     'address':       address,
    if (email != null)       'email':         email,
    if (phone != null)       'phone':         phone,
  };
}