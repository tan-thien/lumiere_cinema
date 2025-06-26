import 'package:flutter/material.dart';
import 'package:lumiere_cinema/screens/Admin/schedule/schedule_list_screen.dart';
import 'branch/branch_screen.dart';
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
        title: 'Quản lý suất chiếu',
        icon: Icons.movie_filter,
        screen: ScheduleListScreen(),
      ),
      _AdminFunction(
        title: 'Quản lý ghế ngồi',
        icon: Icons.event_seat,
        screen: Placeholder(), // TODO: Thay bằng màn hình UserScreen
      ),
      _AdminFunction(
        title: 'Quản lý vé',
        icon: Icons.confirmation_num,
        screen: Placeholder(), // TODO: Thay bằng màn hình UserScreen
      ),
      _AdminFunction(
        title: 'Quản lý người dùng',
        icon: Icons.person,
        screen: Placeholder(), // TODO: Thay bằng màn hình UserScreen
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang quản lý'),

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

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Trang chính'),
              onTap: () => Navigator.pop(context), // đóng drawer
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Quản lý chi nhánh'),
              onTap: () => _navigateTo(context, const BranchScreen()),
            ),
            ListTile(
              leading: Icon(Icons.theaters),
              title: Text('Quản lý rạp phim'),
              onTap: () => _navigateTo(context, const CinemaListScreen()),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Quản lý thể loại phim'),
              onTap: () => _navigateTo(context, const GenreListScreen()),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Quản lý phim'),
              onTap: () => _navigateTo(context, MovieListScreen()),
            ),
            ListTile(
              leading: Icon(Icons.movie_filter),
              title: Text('Quản lý suất chiếu'),
              onTap: () => _navigateTo(context, const ScheduleListScreen()),
            ),
            ListTile(
              leading: Icon(Icons.event_seat),
              title: Text('Quản lý ghế ngồi'),
              onTap: () => _navigateTo(context, const BranchScreen()),
            ),
            ListTile(
              leading: Icon(Icons.confirmation_num),
              title: Text('Quản lý vé'),
              onTap: () => _navigateTo(context, const BranchScreen()),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              onTap: () async {
                Navigator.pop(context); // đóng drawer
                await _authService.logout(context);
              },
            ),
          ],
        ),
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
