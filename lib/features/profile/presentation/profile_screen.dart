import 'package:flutter/material.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/animations.dart';
import '../../shared/widgets/gradient_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _menuGroups = [
    [
      {'icon': Icons.storefront, 'label': '商店', 'color': Color(0xFFE0647C)},
      {'icon': Icons.account_balance_wallet, 'label': '钱包', 'color': Color(0xFFD4AF6A)},
      {'icon': Icons.collections_bookmark, 'label': '收藏馆', 'color': Color(0xFF4FC3B7)},
    ],
    [
      {'icon': Icons.videogame_asset, 'label': 'DM控制台', 'color': Color(0xFF8A5CF6)},
      {'icon': Icons.star, 'label': '徽章', 'color': Color(0xFF4AC29A)},
      {'icon': Icons.flag, 'label': '我的俱乐部', 'color': Color(0xFFE0647C)},
    ],
    [
      {'icon': Icons.settings, 'label': '设置', 'color': Color(0xFF9AA5B1)},
      {'icon': Icons.help_outline, 'label': '帮助', 'color': Color(0xFF9AA5B1)},
      {'icon': Icons.info_outline, 'label': '关于', 'color': Color(0xFF9AA5B1)},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            UIConstants.spacingLg,
            UIConstants.spacingLg,
            UIConstants.spacingLg,
            100,
          ),
          children: [
            const Entrance(
              child: Row(
                children: [
                  GradientAvatar(text: '大', size: 64),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '大侦探2C9F2',
                          style: TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ID: 13743742 · 剧本 12 场 · DM 3 场',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.qr_code, color: Colors.white38),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 资产
            Entrance(
              delay: const Duration(milliseconds: 80),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    _asset(Icons.monetization_on, const Color(0xFFD4AF6A), '150'),
                    _asset(Icons.diamond, const Color(0xFF4FC3B7), '0'),
                    _asset(Icons.local_fire_department, const Color(0xFFE0647C), '连续7天'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 功能菜单
            for (final group in _menuGroups)
              Entrance(
                delay: const Duration(milliseconds: 120),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      for (final item in group)
                        _MenuRow(icon: item['icon'] as IconData,
                            color: item['color'] as Color,
                            label: item['label'] as String),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // 退出登录
            const Entrance(
              child: Center(
                child: Text(
                  '退出登录',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _asset(IconData icon, Color color, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white30, size: 20),
          ],
        ),
      ),
    );
  }
}