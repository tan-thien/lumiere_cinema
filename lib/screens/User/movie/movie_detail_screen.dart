import 'package:flutter/material.dart';
import 'package:lumiere_cinema/models/movie_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:ui';
import 'package:lumiere_cinema/models/schedule_model.dart';
import 'package:lumiere_cinema/services/schedule_service.dart';
import 'booking_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late YoutubePlayerController _youtubeController;
  late Future<List<Schedule>> _scheduleFuture;
  DateTime selectedDate = DateTime.now();
  late List<DateTime> next7Days;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.movie.trailerUrl);
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    // Lấy lịch chiếu theo ID phim
    _scheduleFuture = ScheduleService.getSchedulesByMovieId(widget.movie.id!);

    next7Days = List.generate(8, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DateTime(date.year, date.month, date.day); // chỉ lấy ngày
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trailer with overlayed back button
            Stack(
              children: [
                YoutubePlayer(
                  controller: _youtubeController,
                  showVideoProgressIndicator: true,
                  width: MediaQuery.of(context).size.width,
                ),
                // Back button
                Positioned(
                  top: 32,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(color: Colors.white54),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Poster + Info Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie.anhPhim.isNotEmpty
                          ? movie.anhPhim
                          : 'https://via.placeholder.com/100x150?text=No+Image',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.tenPhim,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${movie.theLoaiTen ?? 'Không rõ'} • ${movie.thoiLuong} phút',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Mô tả phim
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Mô tả:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                movie.moTa.isNotEmpty ? movie.moTa : 'Không có mô tả.',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: next7Days.length,
                itemBuilder: (context, index) {
                  final date = next7Days[index];
                  final isSelected = selectedDate == date;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.blueAccent : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            [
                              'CN',
                              'T2',
                              'T3',
                              'T4',
                              'T5',
                              'T6',
                              'T7',
                            ][date.weekday % 7],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Lịch chiếu:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FutureBuilder<List<Schedule>>(
                future: _scheduleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}');
                  }

                  final schedules = snapshot.data ?? [];

                  if (schedules.isEmpty) {
                    return const Text('Không có lịch chiếu nào.');
                  }

                  // 🔍 Lọc lịch chiếu theo ngày được chọn
                  final filteredSchedules =
                      schedules.where((s) {
                        final showDate = DateTime(
                          s.gioChieu.year,
                          s.gioChieu.month,
                          s.gioChieu.day,
                        );
                        return showDate == selectedDate;
                      }).toList();

                  if (filteredSchedules.isEmpty) {
                    return const Text('Không có lịch chiếu nào cho ngày này.');
                  }

                  // 🔄 Gom nhóm theo rạp
                  final Map<String, List<Schedule>> groupedByCinema = {};
                  for (var s in filteredSchedules) {
                    final chiNhanh =
                        s.tenChiNhanh ??
                        'Không rõ chi nhánh'; // ✅ dùng chi nhánh thay vì rạp
                    groupedByCinema.putIfAbsent(chiNhanh, () => []).add(s);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        groupedByCinema.entries.map((entry) {
                          final chiNhanh = entry.key;
                          final suatChieus = entry.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      chiNhanh,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    // Bạn có thể thêm khoảng cách hoặc khoảng cách địa lý nếu có
                                  ],
                                ),
                                const SizedBox(height: 8),
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: suatChieus.map((s) {
    final gio = '${s.gioChieu.hour.toString().padLeft(2, '0')}:${s.gioChieu.minute.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: () {
        // 👉 Khi bấm giờ chiếu thì chuyển sang BookingScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              movie: widget.movie,
              schedule: s,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(gio),
      ),
    );
  }).toList(),
)

                              ],
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
