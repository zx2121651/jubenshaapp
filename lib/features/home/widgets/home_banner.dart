import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF2D1E3A), Color(0xFF1E1528)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=600&auto=format&fit=crop',
            ), // Placeholder for banner background
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '大侦探三期',
                  style: TextStyle(
                    color: Color(0xFFFFE5FF),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(color: Colors.purpleAccent, blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0ED), // Light beige
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFD5D5),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '完成30天任务+签到',
                        style: TextStyle(
                          color: Color(0xFF8A6B8A),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '免费获得永久装扮',
                        style: TextStyle(
                          color: Color(0xFF4A2B4A),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Pin icon mock
            const Positioned(
              right: 6,
              top: 6,
              child: Icon(Icons.push_pin, color: Colors.redAccent, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
