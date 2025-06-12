class Branch {
  final String id;
  final String tenChiNhanh;
  final String diaChi;
  final String sdt;
  final bool status;

  Branch({
    required this.id,
    required this.tenChiNhanh,
    required this.diaChi,
    required this.sdt,
    required this.status,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      tenChiNhanh: json['TenChiNhanh'],
      diaChi: json['DiaChi'],
      sdt: json['SDT'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TenChiNhanh': tenChiNhanh,
      'DiaChi': diaChi,
      'SDT': sdt,
      'Status': status,
    };
  }
}
