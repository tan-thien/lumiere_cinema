import 'package:flutter/material.dart';
import 'package:lumiere_cinema/models/movie_model.dart';
import 'package:lumiere_cinema/models/scheduleSeat_model.dart';
import 'package:lumiere_cinema/models/schedule_model.dart';
import 'package:lumiere_cinema/services/scheduleSeat_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lumiere_cinema/services/ticket_service.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

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
    final total = (_selectedSeats.length * 50000 / 24000).toStringAsFixed(
      2,
    ); // chuyển VND → USD (tỉ giá 1USD ~ 24,000 VND)

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
                    "total": total,
                    "currency": "USD",
                    "details": {
                      "subtotal": total,
                      "shipping": '0',
                      "shipping_discount": 0,
                    },
                  },
                  "description": "Thanh toán vé xem phim Lumiere",
                  "item_list": {
                    "items":
                        _selectedSeats.map((seat) {
                          return {
                            "name": seat.seatLabel ?? "Ghế",
                            "quantity": 1,
                            "price": (50000 / 24000).toStringAsFixed(2),
                            "currency": "USD",
                          };
                        }).toList(),
                  },
                },
              ],
              note: "Cảm ơn bạn đã sử dụng Lumiere Cinema!",
              onSuccess: (Map params) async {
                print("Thanh toán thành công: $params");
                await bookTickets();

                Navigator.of(context).popUntil((route) => route.isFirst);

                // Đợi một chút rồi hiện snackbar ở Home
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
      appBar: AppBar(title: const Text('Đặt vé')),
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
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '🎬 ${widget.movie.tenPhim}\n🕒 $gioChieuFormatted',
                  style: const TextStyle(fontSize: 16),
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
                      // Thanh ngang nhỏ
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

                      // Khu vực ghế - cuộn ngang/dọc
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
                                                  return GestureDetector(
                                                    onTap:
                                                        seat.isReserved
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
                                                            seat.isReserved
                                                                ? Colors.grey
                                                                : isSelected
                                                                ? Colors.blue
                                                                : Colors.white,
                                                        border: Border.all(
                                                          color: Colors.black,
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
                                                              seat.isReserved
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

                // child: ElevatedButton.icon(
                //   onPressed: _selectedSeats.isEmpty ? null : bookTickets,
                //   icon: const Icon(Icons.payment),
                //   label: Text('Đặt ${_selectedSeats.length} vé'),
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size.fromHeight(48),
                //   ),
                // ),
                child: ElevatedButton.icon(
                  onPressed:
                      _selectedSeats.isEmpty ? null : startPayPalCheckout,
                  icon: const Icon(Icons.payment),
                  label: Text('Thanh toán ${_selectedSeats.length} vé'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
