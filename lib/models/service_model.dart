class Service {
  final String? id;
  final String tenDichVu;
  final String moTa;
  final int gia;
  final String hinhAnh;
  final bool trangThai;

  Service({
    this.id,
    required this.tenDichVu,
    required this.moTa,
    required this.gia,
    required this.hinhAnh,
    this.trangThai = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      tenDichVu: json['TenDichVu'],
      moTa: json['MoTa'] ?? '',
      gia: json['Gia'],
      hinhAnh: json['HinhAnh'],
      trangThai: json['TrangThai'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'TenDichVu': tenDichVu,
      'MoTa': moTa,
      'Gia': gia,
      'HinhAnh': hinhAnh,
      'TrangThai': trangThai,
    };
  }
}
