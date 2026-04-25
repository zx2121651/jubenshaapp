import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingLg,
        vertical: UIConstants.spacingSm,
      ),
      child: Row(
        children: [
          Row(
            children: const [
              Text(
                '北京市',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 20, color: AppTheme.onSurface),
            ],
          ),
          const SizedBox(width: UIConstants.spacingLg),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(UIConstants.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: AppTheme.onSurfaceVariant),
                  const SizedBox(width: UIConstants.spacingSm),
                  Text(
                    '搜索剧本/门店/玩家',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
