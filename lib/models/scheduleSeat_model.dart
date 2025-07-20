class ScheduleSeat {
  final String id;
  final bool isReserved;
  final String? seatLabel; // VD: A1, B5
  final String? seatType;

  ScheduleSeat({
    required this.id,
    required this.isReserved,
    this.seatLabel,
    this.seatType,
  });

  factory ScheduleSeat.fromJson(Map<String, dynamic> json) {
    final seat = json['SeatId'];
    return ScheduleSeat(
      id: json['_id'],
      isReserved: json['IsReserved'] ?? false,
      seatLabel: seat?['SoGhe'] ?? '',
      seatType: seat?['LoaiGhe'] ?? '',
    );
  }
}
