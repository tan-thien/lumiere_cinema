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
  final Set<int> expandedIndexSet = {};
  final Color orangeColor = Color(0xFFFFA726); // Cam nhẹ
  final Color blueColor = Color(0xFF005AA7);

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    final data = await TicketService.fetchTicketHistory();
    setState(() {
      tickets = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Ticket>> groupedTickets = {};
    for (var t in tickets) {
      String dateKey = DateFormat('dd/MM/yyyy').format(t.bookingTime);
      groupedTickets.putIfAbsent(dateKey, () => []).add(t);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đặt vé', style: TextStyle(color: Colors.black,), ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: blueColor))
          : tickets.isEmpty
              ? Center(child: Text('Bạn chưa có vé nào.'))
              : ListView.builder(
                  itemCount: groupedTickets.keys.length,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  itemBuilder: (context, groupIndex) {
                    String dateKey = groupedTickets.keys.elementAt(groupIndex);
                    List<Ticket> group = groupedTickets[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12, top: 10, bottom: 4),
                          child: Text(
                            dateKey,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        ...group.asMap().entries.map((entry) {
                          int localIndex = entry.key;
                          int globalIndex = tickets.indexOf(entry.value);
                          Ticket t = entry.value;
                          bool isExpanded = expandedIndexSet.contains(globalIndex);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TicketQRScreen(ticketId: t.id!),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.movie, color: orangeColor),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            t.movieTitle,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blueColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            color: orangeColor),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child:
                                              Text('Rạp: ${t.cinemaName}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.event_seat_outlined,
                                            color: orangeColor),
                                        SizedBox(width: 6),
                                        Text('Ghế: ${t.seatLabel} (${t.seatType})'),
                                      ],
                                    ),

                                    /// Chi tiết ẩn hiện
                                    AnimatedCrossFade(
                                      crossFadeState: isExpanded
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      duration: Duration(milliseconds: 300),
                                      firstChild: SizedBox.shrink(),
                                      secondChild: Column(
                                        children: [
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time,
                                                  color: orangeColor),
                                              SizedBox(width: 6),
                                              Text(
                                                  'Giờ chiếu: ${DateFormat('dd/MM/yyyy HH:mm').format(t.showTime)}'),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.attach_money,
                                                  color: orangeColor),
                                              SizedBox(width: 6),
                                              Text(
                                                'Giá: ${NumberFormat.decimalPattern().format(t.gia)} đ',
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                  Icons
                                                      .calendar_today_outlined,
                                                  color: orangeColor),
                                              SizedBox(width: 6),
                                              Text(
                                                  'Đặt lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(t.bookingTime)}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4),

                                    /// Nút xem thêm chính giữa
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (isExpanded) {
                                              expandedIndexSet
                                                  .remove(globalIndex);
                                            } else {
                                              expandedIndexSet
                                                  .add(globalIndex);
                                            }
                                          });
                                        },
                                        child: Text(
                                          isExpanded ? 'Thu gọn' : 'Xem thêm',
                                          style: TextStyle(color: orangeColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
    );
  }
}
