import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomePlaySection extends StatelessWidget {
  const HomePlaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
          child: Text(
            '剧好玩',
            style: TextStyle(
              color: AppTheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: UIConstants.spacingMd),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingLg,
          ),
          child: SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildLargeCard(
                    title: '玩剧本',
                    subtitle: '拨开迷雾 寻找真相',
                    badge: '93万学！',
                    gradient: AppTheme.playScriptGradient,
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: UIConstants.spacingSm),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildSmallCard(
                          title: '真人带本',
                          badge: '首同特惠',
                          gradient: AppTheme.liveActionGradient,
                          textColor: Colors.black,
                          badgeColor: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingSm),
                      Expanded(
                        child: _buildSmallCard(
                          title: '十分钟剧本',
                          subtitle: '剧本盲盒',
                          gradient: AppTheme.tenMinScriptGradient,
                          textColor: Colors.black,
                          badgeColor: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: UIConstants.spacingLg),
        _buildHorizontalGameList(),
      ],
    );
  }

  Widget _buildLargeCard({
    required String title,
    required String subtitle,
    required String badge,
    required Gradient gradient,
    required Color textColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'GO',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Badge overlapping top left
        Positioned(
          top: -6,
          left: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Placeholder for the 3D character icon
        Positioned(
          bottom: -10,
          right: -10,
          child: Icon(
            Icons.smart_toy,
            size: 90,
            color: Colors.blue.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallCard({
    required String title,
    String? subtitle,
    String? badge,
    required Gradient gradient,
    required Color textColor,
    Color? badgeColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (badge == null) const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (badge != null && badgeColor != null)
          Positioned(
            top: -6,
            left: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        // Placeholder icons
        Positioned(
          bottom: -5,
          right: -5,
          child: Icon(
            subtitle == null ? Icons.face : Icons.card_giftcard,
            size: 50,
            color: (subtitle == null ? Colors.pink : Colors.orange).withValues(
              alpha: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalGameList() {
    final gamesFixed = [
      {
        'title': '谁是卧底',
        'icon': Icons.person_search,
        'color': const Color(0xFF3D4A2E),
      },
      {
        'title': '你画我猜',
        'icon': Icons.palette,
        'color': const Color(0xFF4A452E),
      },
      {'title': '炸弹猫', 'icon': Icons.pets, 'color': const Color(0xFF412C46)},
      {
        'title': '骑士...',
        'icon': Icons.security,
        'color': const Color(0xFF4C382E),
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
        scrollDirection: Axis.horizontal,
        itemCount: gamesFixed.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: UIConstants.spacingMd),
        itemBuilder: (context, index) {
          final game = gamesFixed[index];
          return Container(
            width: 80,
            decoration: BoxDecoration(
              color: game['color'] as Color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  game['icon'] as IconData,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 40,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    game['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
