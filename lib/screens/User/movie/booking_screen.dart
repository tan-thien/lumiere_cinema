import 'package:flutter/material.dart';
import 'package:lumiere_cinema/models/movie_model.dart';
import 'package:lumiere_cinema/models/scheduleSeat_model.dart';
import 'package:lumiere_cinema/models/schedule_model.dart';
import 'package:lumiere_cinema/services/scheduleSeat_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lumiere_cinema/services/ticket_service.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Movie movie;
  final Schedule schedule;

  const BookingScreen({super.key, required this.movie, required this.schedule});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late Future<List<ScheduleSeat>> _seatsFuture;
  final List<ScheduleSeat> _selectedSeats = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _seatsFuture = ScheduleSeatService.getByScheduleId(widget.schedule.id!);
  }

  void toggleSeat(ScheduleSeat seat) {
    setState(() {
      if (_selectedSeats.contains(seat)) {
        _selectedSeats.remove(seat);
      } else {
        _selectedSeats.add(seat);
      }
    });
  }

  Future<void> bookTickets() async {
    setState(() => _isLoading = true); // Tùy bạn muốn hiện loading không

    try {
      for (final seat in _selectedSeats) {
        await TicketService.bookTicket(
          scheduleSeatId: seat.id!, // lấy ID ghế theo lịch chiếu
          gia: 50000, // bạn có thể dùng giá động nếu muốn
        );
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Đặt vé thành công!')));

      Navigator.pop(
        context,
      ); // quay lại màn hình trước (hoặc tới trang vé đã đặt)
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Lỗi: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void startPayPalCheckout() {
    const vndToUsdRate = 24000;
    const priceVnd = 50000;

    // Tính danh sách item từ ghế đã chọn
    final List<Map<String, dynamic>> items =
        _selectedSeats.map((seat) {
          final priceUsd = priceVnd / vndToUsdRate;
          return {
            "name": seat.seatLabel ?? "Ghế",
            "quantity": 1,
            "price": priceUsd.toStringAsFixed(2),
            "currency": "USD",
          };
        }).toList();

    // ✅ Tính lại subtotal bằng cách cộng từng item price (tránh sai số)
    double subtotal = items.fold(0.0, (sum, item) {
      return sum + double.parse(item["price"]);
    });

    String subtotalStr = subtotal.toStringAsFixed(2);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (BuildContext context) => PaypalCheckoutView(
              sandboxMode: true,
              clientId:
                  "AfwJlRu9yKhQRe-sZG2u1zKKPQ5YQLoJFYT9cO5fk9oeBlUQV40ALhAdebTtpW5juHbxxBCT8zhZENoa",
              secretKey:
                  "EP3BjWMcbooXTSCYZk5wOPotdA_kp35NJVLP5CKNe17ab_APS-3lqZFIwK9GhiTN1CVGEWJlo_fiFBlu",
              transactions: [
                {
                  "amount": {
                    "total": subtotalStr,
                    "currency": "USD",
                    "details": {
                      "subtotal": subtotalStr,
                      "shipping": "0",
                      "shipping_discount": "0",
                    },
                  },
                  "description": "Thanh toán vé xem phim Lumiere",
                  "item_list": {"items": items},
                },
              ],
              note: "Cảm ơn bạn đã sử dụng Lumiere Cinema!",
              onSuccess: (Map params) async {
                print("Thanh toán thành công: $params");
                await bookTickets();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Future.delayed(const Duration(milliseconds: 300), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Thanh toán và đặt vé thành công!'),
                    ),
                  );
                });
              },
              onError: (error) {
                print("Lỗi PayPal: $error");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❌ Thanh toán thất bại')),
                );
              },
              onCancel: () {
                print('Thanh toán bị huỷ');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🚫 Đã huỷ thanh toán')),
                );
              },
            ),
      ),
    );
  }

  // 🧠 Gom nhóm ghế theo dòng (A, B, C,...)
  Map<String, List<ScheduleSeat>> groupSeatsByRow(List<ScheduleSeat> seats) {
    final Map<String, List<ScheduleSeat>> grouped = {};

    for (final seat in seats) {
      final label = seat.seatLabel ?? '';
      final rowMatch = RegExp(r'([A-Z]+)').firstMatch(label);
      if (rowMatch != null) {
        final row = rowMatch.group(1)!;
        grouped.putIfAbsent(row, () => []).add(seat);
      }
    }

    // Sắp xếp dòng theo thứ tự alphabet
    final sortedKeys = grouped.keys.toList()..sort();

    // Sắp xếp từng dòng theo số ghế (cột)
    for (var key in grouped.keys) {
      grouped[key]!.sort((a, b) {
        final colA =
            int.tryParse(
              RegExp(r'\d+').firstMatch(a.seatLabel!)?.group(0) ?? '',
            ) ??
            0;
        final colB =
            int.tryParse(
              RegExp(r'\d+').firstMatch(b.seatLabel!)?.group(0) ?? '',
            ) ??
            0;
        return colA.compareTo(colB);
      });
    }

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt vé'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ScheduleSeat>>(
        future: _seatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Text('Lỗi: ${snapshot.error}');
          final seats = snapshot.data ?? [];

          final groupedSeats = groupSeatsByRow(seats);

          final gioChieuFormatted = DateFormat(
            'EEEE, d MMMM yyyy - HH:mm',
            'vi',
          ).format(widget.schedule.gioChieu);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.movie.tenPhim,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      gioChieuFormatted,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendBox(const Color(0xFFFFA726), 'Đã đặt'),
                        const SizedBox(width: 16),
                        _buildLegendBox(const Color(0xFF1565C0), 'Đang chọn'),
                        const SizedBox(width: 16),
                        _buildLegendBox(
                          Colors.white,
                          'Còn trống',
                          border: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Màn hình',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children:
                                  groupedSeats.entries.map((entry) {
                                    final row = entry.key;
                                    final rowSeats = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            child: Text(
                                              row,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Wrap(
                                            spacing: 8,
                                            children:
                                                rowSeats.map((seat) {
                                                  final isSelected =
                                                      _selectedSeats.contains(
                                                        seat,
                                                      );
                                                  final bool isReserved =
                                                      seat.isReserved;
                                                  return GestureDetector(
                                                    onTap:
                                                        isReserved
                                                            ? null
                                                            : () => toggleSeat(
                                                              seat,
                                                            ),
                                                    child: Container(
                                                      width: 36,
                                                      height: 36,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            isReserved
                                                                ? const Color(
                                                                  0xFFFFA726,
                                                                )
                                                                : isSelected
                                                                ? const Color(
                                                                  0xFF1565C0,
                                                                )
                                                                : Colors.white,
                                                        border: Border.all(
                                                          color:
                                                              isReserved
                                                                  ? const Color(
                                                                    0xFFFFA726,
                                                                  )
                                                                  : const Color(
                                                                    0xFFFFA726,
                                                                  ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        seat.seatLabel ?? '',
                                                        style: TextStyle(
                                                          color:
                                                              isReserved ||
                                                                      isSelected
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 👇 Thêm phần tổng cộng vào đây
                    if (_selectedSeats.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(_selectedSeats.length * 50000)} (${_selectedSeats.length} vé)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // 👇 Nút thanh toán giữ nguyên
                    ElevatedButton.icon(
                      onPressed:
                          _selectedSeats.isEmpty ? null : startPayPalCheckout,
                      icon: const Icon(Icons.payment),
                      label: Text('Thanh toán ${_selectedSeats.length} vé'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedSeats.isEmpty
                                ? Colors.grey
                                : const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildLegendBox(Color color, String label, {bool border = false}) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          border: border ? Border.all(color: const Color(0xFFFFA726)) : null,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 14)),
    ],
  );
}
