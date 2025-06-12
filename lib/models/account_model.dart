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
      id: json['id'],
      tenTK: json['TenTK'],
      email: json['email'],
      role: json['role'],
      trangthai: json['trangthai'],
    );
  }
}
