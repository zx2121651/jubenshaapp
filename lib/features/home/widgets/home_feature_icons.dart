import 'package:flutter/material.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';

class HomeFeatureIcons extends StatelessWidget {
  const HomeFeatureIcons({super.key});

  static const List<Map<String, dynamic>> items = [
    {'icon': Icons.emoji_events, 'label': '排行榜', 'color': Color(0xFFD4AF6A), 'badge': null},
    {'icon': Icons.auto_awesome, 'label': '活动', 'color': Color(0xFF8A5CF6), 'badge': null},
    {'icon': Icons.storefront, 'label': '收藏馆', 'color': Color(0xFF4FC3B7), 'badge': 'NEW'},
    {'icon': Icons.groups, 'label': '俱乐部', 'color': Color(0xFFC9A15E), 'badge': null},
    {'icon': Icons.assignment, 'label': '任务', 'color': Color(0xFFE0647C), 'badge': 'DOT'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Entrance(
            delay: Duration(milliseconds: 80 + index * 55),
            offset: const Offset(0, 14),
            child: _IconItem(item: item),
          );
        }).toList(),
      ),
    );
  }
}

class _IconItem extends StatefulWidget {
  const _IconItem({required this.item});

  final Map<String, dynamic> item;

  @override
  State<_IconItem> createState() => _IconItemState();
}

class _IconItemState extends State<_IconItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {},
      child: AnimatedScale(
        scale: _pressed ? 0.86 : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.bounceOut,
        child: Column(
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
                  const Positioned(
                    top: -8,
                    right: -12,
                    child: _TagBadge(label: 'NEW'),
                  ),
                if (item['badge'] == 'DOT')
                  const Positioned(
                    top: -2,
                    right: 2,
                    child: _BadgeDot(),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item['label'] as String,
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  const _TagBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.background, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BadgeDot extends StatelessWidget {
  const _BadgeDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.background, width: 1.5),
      ),
    );
  }
}