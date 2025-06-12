import 'package:flutter/material.dart';
import 'branch_screen.dart';
import 'cinema/cinema_list_screen.dart';
import 'genre/genre_list_screen.dart';
import '../../services/auth_service.dart';
import '../Admin/movie/movie_list_screen.dart';


class AdminHomeScreen extends StatelessWidget {
   AdminHomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // Tạo instance AuthService
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final List<_AdminFunction> functions = [
      _AdminFunction(
        title: 'Quản lý chi nhánh',
        icon: Icons.store,
        screen: const BranchScreen(),
      ),
      _AdminFunction(
        title: 'Quản lý rạp phim',
        icon: Icons.theaters,
        screen: CinemaListScreen(), 
      ),

      _AdminFunction(
        title: 'Quản lý thể loại phim',
        icon: Icons.category,
        screen: GenreListScreen(), 
      ),

      _AdminFunction(
        title: 'Quản lý phim',
        icon: Icons.movie,
        screen: MovieListScreen(), 
      ),

      _AdminFunction(
        title: 'Quản lý người dùng',
        icon: Icons.person,
        screen: Placeholder(), // TODO: Thay bằng màn hình UserScreen
      ),
      _AdminFunction(
        title: 'Quản lý suất chiếu',
        icon: Icons.movie_filter,
        screen: Placeholder(), // TODO: Thay bằng màn hình ShowtimesScreen
      ),
      _AdminFunction(
        title: 'Phòng chiếu',
        icon: Icons.meeting_room,
        screen: Placeholder(), // TODO: Thay bằng màn hình RoomsScreen
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Trang quản lý Admin'),
      
              actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              // Gọi logout trong AuthService
              await _authService.logout(context);
            },
          ),
        ],
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: functions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cột
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = functions[index];
            return GestureDetector(
              onTap: () => _navigateTo(context, item.screen),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AdminFunction {
  final String title;
  final IconData icon;
  final Widget screen;

  _AdminFunction({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
