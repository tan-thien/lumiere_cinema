import 'package:flutter/material.dart';
import 'package:lumiere_cinema/models/movie_model.dart';
import 'package:lumiere_cinema/services/movie_service.dart';
import 'package:lumiere_cinema/screens/User/movie/movie_detail_screen.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieService.getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final movies = snapshot.data ?? [];

        if (movies.isEmpty) {
          return const Center(child: Text('Không có phim nào.'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // để scroll ở ListView cha
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.66,
          ),
          itemBuilder: (context, index) {
            final movie = movies[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailScreen(movie: movie),
                  ),
                );
              },

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🟢 Ảnh poster chiếm hết chiều cao còn lại
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          movie.anhPhim.isNotEmpty
                              ? movie.anhPhim
                              : 'https://via.placeholder.com/200x300?text=No+Image',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    // 🟡 Tên phim co giãn nếu dài, tránh tràn
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        movie.tenPhim,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
