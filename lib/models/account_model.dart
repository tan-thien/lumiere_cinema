class Account {
  final String id;
  final String tenTK;
  final String email;
  final String role;
  final bool trangthai;

  Account({
    required this.id,
    required this.tenTK,
    required this.email,
    required this.role,
    required this.trangthai,
  });

factory Account.fromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id']?.toString() ?? '',                      // ép sang String
    tenTK: json['TenTK']?.toString() ?? 'Chưa có tên',      // fallback nếu thiếu
    email: json['email']?.toString() ?? 'Không có email',
    role: json['role']?.toString() ?? 'user',
    trangthai: json['trangthai'] == true,                   // fallback false nếu null
  );
}

}
