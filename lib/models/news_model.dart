class News {
  final String id;
  final String tieuDe;
  final String noiDung;
  final String anhTinTuc;
  final String? tenPhim; // nếu có populate
  final bool trangThai;

  News({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    required this.anhTinTuc,
    this.tenPhim,
    required this.trangThai,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'],
      tieuDe: json['TieuDe'],
      noiDung: json['NoiDung'],
      anhTinTuc: json['AnhTinTuc'],
      tenPhim: json['MaPhim'] is Map ? json['MaPhim']['TenPhim'] : null,
      trangThai: json['TrangThai'],
    );
  }
}
