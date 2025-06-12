class Cinema {
  final String? id;
  final String tenRap;
  final int soLuongGhe;
  final bool trangThai;
  final String? maChiNhanh;

  Cinema({
    this.id,
    required this.tenRap,
    required this.soLuongGhe,
    this.trangThai = true,
    this.maChiNhanh,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['_id'],
      tenRap: json['TenRap'],
      soLuongGhe: json['SoLuongGhe'],
      trangThai: json['TrangThai'],
      maChiNhanh: json['MaChiNhanh'] is Map
          ? json['MaChiNhanh']['_id']
          : json['MaChiNhanh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TenRap': tenRap,
      'SoLuongGhe': soLuongGhe,
      'TrangThai': trangThai,
      'MaChiNhanh': maChiNhanh,
    };
  }
}
