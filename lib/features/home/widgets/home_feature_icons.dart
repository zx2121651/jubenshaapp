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
      'icon': Icons.auto_awesome,
      'label': '活动',
      'color': Colors.purpleAccent,
      'badge': null,
    },
    {
      'icon': Icons.store,
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
      'icon': Icons.assignment,
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
          alignment: Alignment.center,
          children: [
            Icon(
              item['icon'] as IconData,
              color: item['color'] as Color,
              size: 40,
            ),
            if (item['badge'] == 'NEW')
              Positioned(
                top: -8,
                right: -12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(6),
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
                top: -2,
                right: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.background, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          item['label'] as String,
          style: const TextStyle(
            color: AppTheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
