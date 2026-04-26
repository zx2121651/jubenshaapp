import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomeFeedList extends StatelessWidget {
  const HomeFeedList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data matching the screenshot
    final feeds = [
      {
        'user': '最低价要的来啊 互关',
        'message': '互关任务50 + 111111111111',
        'avatar':
            'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=100&auto=format&fit=crop&q=60',
      },
      {
        'user': '塔 不限 DD一下',
        'message': '主页互赞互赞互赞互赞点头像有惊喜',
        'avatar':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&auto=format&fit=crop&q=60',
      },
      {
        'user': '全',
        'message': '记得坦诚 全服告白 不爱记得坦诚,...',
        'avatar':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=60',
        'isSpecial': true,
      },
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final feed = feeds[index];
        final isSpecial = feed['isSpecial'] == true;

        return Padding(
          padding: const EdgeInsets.only(bottom: UIConstants.spacingSm),
          child: Row(
            children: [
              // Left part: user/tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    if (isSpecial)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.favorite,
                          color: AppTheme.primary,
                          size: 14,
                        ),
                      ),
                    Text(
                      feed['user'] as String,
                      style: const TextStyle(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Gap
              const SizedBox(width: 2),
              // Right part: message
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(feed['avatar'] as String),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feed['message'] as String,
                          style: const TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.edit_outlined,
                        color: AppTheme.onSurfaceVariant,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }, childCount: feeds.length),
    );
  }
}
