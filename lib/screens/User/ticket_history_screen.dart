import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/ticket_model.dart';
import '/services/ticket_service.dart'; 
import 'package:lumiere_cinema/screens/User/ticket_qr_screen.dart';

class TicketHistoryScreen extends StatefulWidget {
  @override
  _TicketHistoryScreenState createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  List<Ticket> tickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    final data =
        await TicketService.fetchTicketHistory(); // tự viết service này
    setState(() {
      tickets = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử đặt vé')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : tickets.isEmpty
              ? Center(child: Text('Bạn chưa có vé nào.'))
              : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final t = tickets[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketQRScreen(ticketId: t.id!),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎬 ${t.movieTitle}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('🏢 Rạp: ${t.cinemaName}'),
                            Text('💺 Ghế: ${t.seatLabel} (${t.seatType})'),
                            Text(
                              '🕒 Giờ chiếu: ${DateFormat('dd/MM/yyyy HH:mm').format(t.showTime)}',
                            ),
                            Text('💰 Giá: ${t.gia}'),
                            Text('📌 Trạng thái: ${t.status}'),
                            Text(
                              '📆 Đặt lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(t.bookingTime)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
