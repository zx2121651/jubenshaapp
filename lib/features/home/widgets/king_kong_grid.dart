import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';

class KingKongGrid extends StatelessWidget {
  const KingKongGrid({super.key});

  final List<Map<String, dynamic>> items = const [
    {'icon': Icons.menu_book, 'label': '海量剧本'},
    {'icon': Icons.storefront, 'label': '发现门店'},
    {'icon': Icons.people_outline, 'label': '组局大厅'},
    {'icon': Icons.event, 'label': '剧本展会'},
    {'icon': Icons.leaderboard, 'label': '热门榜单'},
    {'icon': Icons.school, 'label': '新手教程'},
    {'icon': Icons.work_outline, 'label': 'DM招募'},
    {'icon': Icons.dashboard_customize, 'label': '全部'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg, vertical: UIConstants.spacingMd),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: UIConstants.spacingMd,
          crossAxisSpacing: UIConstants.spacingMd,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  items[index]['icon'],
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: UIConstants.spacingXs),
              Text(
                items[index]['label'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
