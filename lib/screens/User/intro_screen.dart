import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumiere_cinema/screens/login_screen.dart'; // hoặc UserHomeScreen

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/logoblack.PNG',
      'title': 'Chào mừng đến Lumiere Cinema',
      'desc': 'Nơi hội tụ những bộ phim đỉnh cao và trải nghiệm điện ảnh tuyệt vời.'
    },
    {
      'image': 'assets/images/background.jpg',
      'title': 'Đặt vé dễ dàng',
      'desc': 'Chỉ vài chạm là bạn có thể chọn ghế, đặt vé và thanh toán online tiện lợi.'
    },
    {
      'image': 'assets/images/regis.jpg',
      'title': 'Ưu đãi hấp dẫn',
      'desc': 'Nhận khuyến mãi mỗi tuần và tích điểm đổi quà khi xem phim cùng Lumiere.'
    },
  ];

  void _nextPage() {
    if (_currentIndex < pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishIntro();
    }
  }

  void _finishIntro() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenIntro', true);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (_, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(pages[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          pages[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          pages[index]['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pages.length,
                            (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentIndex == i ? 12 : 8,
                              height: _currentIndex == i ? 12 : 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == i ? Colors.white : Colors.white38,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _nextPage,
                          child: Text(
                            _currentIndex == pages.length - 1 ? 'BẮT ĐẦU' : 'TIẾP THEO',
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
