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
              fontSize: 18,
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
            height: 180,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildLargeCard(
                    title: '玩剧本',
                    subtitle: '拨开迷雾 寻找真相',
                    badge: '93万学！', // Mock text
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
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingSm),
                      Expanded(
                        child: _buildSmallCard(
                          title: '十分钟剧本',
                          subtitle: '剧本盲盒',
                          gradient: AppTheme.tenMinScriptGradient,
                          textColor: Colors.black,
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
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'GO',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Placeholder for the 3D character icon
          Positioned(
            bottom: 0,
            right: -10,
            child: Icon(
              Icons.smart_toy,
              size: 100,
              color: Colors.blue.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required String title,
    String? subtitle,
    String? badge,
    required Gradient gradient,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (badge == null) const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          // Placeholder icons
          Positioned(
            bottom: -5,
            right: 0,
            child: Icon(
              subtitle == null ? Icons.face : Icons.card_giftcard,
              size: 60,
              color: (subtitle == null ? Colors.pink : Colors.orange)
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalGameList() {

    // Correction for olive
    final gamesFixed = [
      {
        'title': '谁是卧底',
        'icon': Icons.person_search,
        'color': const Color(0xFF2E4C2E),
      },
      {
        'title': '你画我猜',
        'icon': Icons.palette,
        'color': const Color(0xFF4C4D2E),
      },
      {'title': '炸弹猫', 'icon': Icons.pets, 'color': const Color(0xFF3B2E4C)},
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
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    game['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
