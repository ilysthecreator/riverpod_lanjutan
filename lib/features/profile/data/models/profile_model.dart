class ProfileModel {
  final String nama;
  final String email;
  final String role;
  final String phone;
  final String joinDate;

  ProfileModel({
    required this.nama,
    required this.email,
    required this.role,
    required this.phone,
    required this.joinDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      joinDate: json['join_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'role': role,
      'phone': phone,
      'join_date': joinDate,
    };
  }
}
