import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/script_model.dart';

class ScriptCard extends StatelessWidget {
  final ScriptModel script;

  const ScriptCard({super.key, required this.script});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(UIConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(UIConstants.radiusMd)),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: CachedNetworkImage(
                imageUrl: script.coverUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppTheme.surfaceContainerLow),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(UIConstants.spacingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  script.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: UIConstants.spacingXs),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: script.tags.map((tag) => _buildTag(tag)).toList(),
                ),
                const SizedBox(height: UIConstants.spacingSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: CachedNetworkImageProvider(script.authorAvatar),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          script.authorName,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 14, color: AppTheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          '${script.likes}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(UIConstants.radiusSm),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
