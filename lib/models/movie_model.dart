class Movie {
  final String? id;
  final String tenPhim;
  final String moTa;
  final int thoiLuong;
  final DateTime ngay;
  final String anhPhim;
  final String trailerUrl;
  final bool trangThai;
  final String maTheLoai;
  final String? theLoaiTen;

  Movie({
    this.id,
    required this.tenPhim,
    required this.moTa,
    required this.thoiLuong,
    required this.ngay,
    required this.anhPhim,
    required this.trailerUrl,
    required this.trangThai,
    required this.maTheLoai,
    this.theLoaiTen,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final theLoai = json['MaTheLoai'];
    return Movie(
      id: json['_id'],
      tenPhim: json['TenPhim'] ?? 'Không rõ',
      moTa: json['MoTa'] ?? '',
      thoiLuong: json['ThoiLuong'],
      ngay: DateTime.parse(json['Ngay']),
      anhPhim: json['AnhPhim'],
      trailerUrl: json['trailerUrl'] ?? '',
      trangThai: json['TrangThai'],
      maTheLoai: theLoai is Map ? theLoai['_id'] : theLoai,
      theLoaiTen: theLoai is Map ? (theLoai['TenTheLoai'] ?? 'Không rõ') : 'Không rõ',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TenPhim': tenPhim,
      'MoTa': moTa,
      'ThoiLuong': thoiLuong,
      'Ngay': ngay.toIso8601String(),
      'AnhPhim': anhPhim,
      'trailerUrl': trailerUrl,
      'TrangThai': trangThai,
      'MaTheLoai': maTheLoai,
    };
  }
}
