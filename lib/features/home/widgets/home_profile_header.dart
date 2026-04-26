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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12, width: 1),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildCurrencyBadge(
                      Icons.monetization_on,
                      Colors.amber,
                      '150',
                    ),
                    const SizedBox(width: UIConstants.spacingSm),
                    _buildCurrencyBadge(
                      Icons.diamond,
                      Colors.lightBlueAccent,
                      '0',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right Action Button (首充特惠)
          Container(
            height: 40,
            width: 80,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?w=150&auto=format&fit=crop',
                ), // Placeholder for fancy button
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '首充特惠',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyBadge(IconData icon, Color iconColor, String text) {
    return Container(
      height: 20,
      padding: const EdgeInsets.only(left: 4, right: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(
            '$text +',
            style: const TextStyle(
              color: AppTheme.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
