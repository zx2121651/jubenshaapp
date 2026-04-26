import 'package:flutter/material.dart';

class PlayerAvatarWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSpeaking;
  final bool isRightSide; // To adjust text alignment if needed

  const PlayerAvatarWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isSpeaking = false,
    this.isRightSide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Glowing border if speaking
            if (isSpeaking)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            // Avatar image
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSpeaking ? Colors.amber : Colors.white54,
                  width: 2,
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Speaking indicator icon
            if (isSpeaking)
              const Positioned(
                top: 0,
                right: -10,
                child: Icon(
                  Icons.volume_up,
                  color: Colors.amber,
                  size: 20,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        // Player Name
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
