import 'package:flutter/material.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/theme/app_theme.dart';

/// 首页顶部横向分类 Tab：国内剧本杀 App 的招牌信息架构，
/// 覆盖剧本杀/实景/线上/桌游等品类，提供高频切入口。
class HomeCategoryTabs extends StatefulWidget {
  const HomeCategoryTabs({super.key});

  @override
  State<HomeCategoryTabs> createState() => _HomeCategoryTabsState();
}

class _HomeCategoryTabsState extends State<HomeCategoryTabs> {
  static const List<_Category> _categories = [
    _Category(icon: Icons.auto_awesome, label: '剧本杀'),
    _Category(icon: Icons.theaters, label: '实景'),
    _Category(icon: Icons.smart_toy, label: '线上'),
    _Category(icon: Icons.extension, label: '桌游'),
    _Category(icon: Icons.person, label: '一人本'),
    _Category(icon: Icons.map, label: '城市'),
    _Category(icon: Icons.group, label: '展会'),
    _Category(icon: Icons.arrow_forward_ios, label: null),
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final c = _categories[i];
          final selected = _selected == i;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary.withValues(alpha: 0.16)
                    : AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? AppTheme.primary.withValues(alpha: 0.55)
                      : Colors.white10,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (c.icon != null) ...[
                    Icon(
                      c.icon,
                      size: 15,
                      color:
                          selected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                  ],
                  if (c.label != null)
                    Text(
                      c.label!,
                      style: TextStyle(
                        color: selected
                            ? AppTheme.primaryContainer
                            : AppTheme.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Category {
  final IconData? icon;
  final String? label;

  const _Category({this.icon, this.label});
}