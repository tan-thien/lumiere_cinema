// lib/widgets/banner_slider.dart
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
    'https://www.galaxycine.vn/media/2022/11/1/combo-u22-digital-1135x660_1667285093971.jpg',
    'https://www.galaxycine.vn/media/2021/3/30/1135x660_1617094981596.jpg',
    'https://www.galaxycine.vn/media/2021/4/27/1135x660_1619508530964.jpg',
    'https://www.galaxycine.vn/media/2021/3/30/1135x660_1617094981596.jpg',
    'https://www.galaxycine.vn/media/2019/7/3/725x435_1562145236829.jpg',
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
                double page = _pageController.page ?? _pageController.initialPage.toDouble();
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
