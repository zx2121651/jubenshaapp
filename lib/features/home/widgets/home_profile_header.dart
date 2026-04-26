import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomeProfileHeader extends StatelessWidget {
  const HomeProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=150&auto=format&fit=crop&q=60',
                ), // Silhouette placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: UIConstants.spacingMd),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '大侦探2C9F2...',
                  style: TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: UIConstants.spacingXs),
                Row(
                  children: [
                    _buildCurrencyBadge(
                      Icons.monetization_on,
                      Colors.amber,
                      '150 +',
                    ),
                    const SizedBox(width: UIConstants.spacingSm),
                    _buildCurrencyBadge(
                      Icons.diamond,
                      Colors.lightBlueAccent,
                      '0 +',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right Action Button (首充特惠)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.card_giftcard, size: 16, color: Colors.purple),
                SizedBox(width: 4),
                Text(
                  '首充特惠',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyBadge(IconData icon, Color iconColor, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
