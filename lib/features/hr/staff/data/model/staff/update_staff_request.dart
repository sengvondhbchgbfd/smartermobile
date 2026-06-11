class UpdateStaffRequest {
  final int? userId;
  final int? staffRoleId;
  final String? name;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? avatarPublicId;

  const UpdateStaffRequest({
    this.userId,
    this.staffRoleId,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.email,
    this.phone,
    this.avatarUrl,
    this.avatarPublicId,
  });

  Map<String, dynamic> toJson() => {
        if (userId != null) 'user_id': userId,
        if (staffRoleId != null) 'staff_role_id': staffRoleId,
        if (name != null) 'name': name,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        if (address != null) 'address': address,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (avatarPublicId != null) 'avatar_public_id': avatarPublicId,
      };
}