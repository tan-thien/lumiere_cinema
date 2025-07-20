class Ticket {
  final String? id;
  final DateTime bookingTime;
  final int gia;
  final String status;
  final String seatLabel;
  final String seatType;
  final String movieTitle;
  final String cinemaName;
  final DateTime showTime;

  Ticket({
    this.id,
    required this.bookingTime,
    required this.gia,
    required this.status,
    required this.seatLabel,
    required this.seatType,
    required this.movieTitle,
    required this.cinemaName,
    required this.showTime,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
  final scheduleSeat = json['ScheduleSeatId'] ?? {};
  final seat = scheduleSeat['SeatId'] ?? {};
  final schedule = scheduleSeat['ScheduleId'] ?? {};
  final movie = schedule['MaPhim'] ?? {};
  final cinema = schedule['MaRap'] ?? {};

  return Ticket(
    id: json['_id'],
    bookingTime: DateTime.tryParse(json['bookingTime'] ?? '') ?? DateTime.now(),
    gia: int.tryParse(json['Gia'].toString()) ?? 0,
    status: json['TrangThai'] ?? 'reserved',
    seatLabel: seat['SoGhe'] ?? '',
    seatType: seat['LoaiGhe'] ?? '',
    movieTitle: movie['TenPhim'] ?? '',
    cinemaName: cinema['TenRap'] ?? '',
    showTime: DateTime.tryParse(schedule['GioChieu'] ?? '') ?? DateTime.now(),
  );
}

}
