import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class ScaffoldWithBottomNavBar extends StatelessWidget {
  const ScaffoldWithBottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          // Floating Tooltip
          if (navigationShell.currentIndex == 0) // Show on Home tab
            Positioned(
              bottom: 90, // Adjust position to point to the second tab
              left: MediaQuery.of(context).size.width * 0.2 + 20,
              child: _buildTooltip(),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _goBranch,
            backgroundColor: AppTheme.surface,
            indicatorColor: Colors.transparent, // Remove default indicator
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            height: 80,
            destinations: [
              _buildDestination(
                0,
                Icons.face,
                Icons.face,
                '首页',
                navigationShell.currentIndex == 0,
              ),
              _buildDestination(
                1,
                Icons.shield,
                Icons.shield_outlined,
                '剧本',
                navigationShell.currentIndex == 1,
              ),
              _buildDestination(
                2,
                Icons.explore,
                Icons.explore_outlined,
                '互动',
                navigationShell.currentIndex == 2,
              ),
              _buildDestination(
                3,
                Icons.chat_bubble,
                Icons.chat_bubble_outline,
                '消息',
                navigationShell.currentIndex == 3,
              ),
              _buildDestination(
                4,
                Icons.tag_faces,
                Icons.tag_faces,
                '我的',
                navigationShell.currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildDestination(
    int index,
    IconData selectedIcon,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return NavigationDestination(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? AppTheme.onSurface : AppTheme.onSurfaceVariant,
            size: 28,
          ),
          if (index == 0 && !isSelected) // Red dot for Home when not selected
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (index == 3) // Red dot for messages
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }

  Widget _buildTooltip() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            '剧本上新了',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Triangle pointing down
        Positioned(
          bottom: -6,
          child: CustomPaint(
            size: const Size(12, 6),
            painter: _TrianglePainter(),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
