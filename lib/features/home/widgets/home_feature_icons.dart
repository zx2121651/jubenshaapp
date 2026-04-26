import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomeFeatureIcons extends StatelessWidget {
  const HomeFeatureIcons({super.key});

  final List<Map<String, dynamic>> items = const [
    {
      'icon': Icons.emoji_events,
      'label': '排行榜',
      'color': Colors.amber,
      'badge': null,
    },
    {
      'icon': Icons.celebration,
      'label': '活动',
      'color': Colors.purpleAccent,
      'badge': null,
    },
    {
      'icon': Icons.storefront,
      'label': '收藏馆',
      'color': Colors.lightBlue,
      'badge': 'NEW',
    },
    {
      'icon': Icons.groups,
      'label': '俱乐部',
      'color': Colors.yellow,
      'badge': null,
    },
    {
      'icon': Icons.assignment_turned_in,
      'label': '任务',
      'color': Colors.pinkAccent,
      'badge': 'DOT',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) => _buildIconItem(item)).toList(),
      ),
    );
  }

  Widget _buildIconItem(Map<String, dynamic> item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    (item['color'] as Color).withValues(alpha: 0.8),
                    (item['color'] as Color).withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: Colors.white,
                size: 28,
              ),
            ),
            if (item['badge'] == 'NEW')
              Positioned(
                top: -4,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.background, width: 1.5),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (item['badge'] == 'DOT')
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.background, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: UIConstants.spacingSm),
        Text(
          item['label'] as String,
          style: const TextStyle(
            color: AppTheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
