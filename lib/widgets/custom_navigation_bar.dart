import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    
    child: Container(
      margin: const EdgeInsets.only(bottom: 12), // Nhấc thanh nav lên
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Bo tròn 4 góc
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 211, 210, 210).withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home, index: 0),
                _buildNavItem(icon: Icons.local_movies, index: 1),
                _buildNavItem(icon: Icons.shopping_cart, index: 2),
                _buildNavItem(icon: LucideIcons.video, index: 3),
                 _buildNavItem(icon: Icons.person, index: 4),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: isSelected ? const Offset(0, -0.3) : Offset.zero,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.blueAccent, width: 2)
                      : null,
                ),
                child: Icon(
                  icon,
                  size: isSelected ? 28 : 26,
                  color: isSelected
                      ? Colors.blueAccent // ✅ Chuyển sang màu xanh khi được chọn
                      : Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
