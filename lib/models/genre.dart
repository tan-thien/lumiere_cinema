class Genre {
  final String? id;
  final String tenTheLoai;

  Genre({this.id, required this.tenTheLoai});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['_id'],
      tenTheLoai: json['TenTheLoai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TenTheLoai': tenTheLoai,
    };
  }
}
