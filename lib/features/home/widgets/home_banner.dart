import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2A1B38), Color(0xFF1A1525)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop',
            ), // Placeholder for banner background
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Mock banner content to match the screenshot "大侦探三期"
            const Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '大侦探三期',
                  style: TextStyle(
                    color: Color(0xFFFFCCFF), // Pinkish tint
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(color: Colors.purpleAccent, blurRadius: 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '完成30天任务+签到',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '免费获得永久装扮',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
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
              right: 8,
              top: 12,
              child: Icon(Icons.push_pin, color: Colors.redAccent, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
