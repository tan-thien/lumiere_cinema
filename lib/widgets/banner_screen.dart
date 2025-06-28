import 'dart:async';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final List<String> banners = [
        'https://cdn.galaxycine.vn/media/2023/5/15/doraemon-utopia-1_1684121820088.jpg',
    'https://i.ytimg.com/vi/PKsVB1wPZ78/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLCu8FoPhxanKlZxDZPpscTQbGGTbA',
    'https://afamilycdn.com/150157425591193600/2021/10/4/phim-kingdom-vuong-trieu-xac-song-phan-1-2-full-hd-vietsub-1-16333243807721978567362-0-0-394-630-crop-1633326547679730083843.jpg',
    'https://aeonmall-review-rikkei.cdn.vccloud.vn/public/wp/21/news/E1NX4UxlFeJ9uGNhsAjecIyPW2nJzBwHDXcm7VAy.jpg',
    'https://media.baothaibinh.com.vn/upload/news/4_2024/phim_dia_dao_mat_troi_trong_bong_toi_he_lo_nhung_hinh_anh_dau_tien_17443530042024.jpg',

  ];

  int _currentPage = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % banners.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double scale = 1.0;
              if (_pageController.position.haveDimensions) {
                double page =
                    _pageController.page ??
                    _pageController.initialPage.toDouble();
                scale = (1 - (page - index).abs() * 0.1).clamp(0.9, 1.0);
              }

              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(banners[index], fit: BoxFit.cover),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
