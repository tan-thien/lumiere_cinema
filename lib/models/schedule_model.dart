class Schedule {
  final String? id;
  final DateTime gioChieu;
  final bool trangThai;
  final String maPhim;
  final String maRap;
  final String? tenPhim; // Lấy từ populate
  final String? tenRap;
  final String? tenChiNhanh;

  Schedule({
    this.id,
    required this.gioChieu,
    required this.trangThai,
    required this.maPhim,
    required this.maRap,
    this.tenPhim,
    this.tenRap,
    this.tenChiNhanh,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['_id'],
      gioChieu: DateTime.parse(json['GioChieu']),
      trangThai: json['TrangThai'],
      maPhim: json['MaPhim'] is Map ? json['MaPhim']['_id'] : json['MaPhim'],
      maRap:
          json['MaRap'] is Map
              ? json['MaRap']['_id'] ?? ''
              : json['MaRap'] ?? '',
      tenPhim: json['MaPhim'] is Map ? json['MaPhim']['TenPhim'] : null,
      tenRap: json['MaRap'] is Map ? json['MaRap']['TenRap'] : null,

      tenChiNhanh:
          json['MaRap'] is Map && json['MaRap']['MaChiNhanh'] is Map
              ? json['MaRap']['MaChiNhanh']['TenChiNhanh']
              : null, // ✅ lấy từ nested populate
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GioChieu': gioChieu.toIso8601String(),
      'TrangThai': trangThai,
      'MaPhim': maPhim,
      'MaRap': maRap,
    };
  }
}
