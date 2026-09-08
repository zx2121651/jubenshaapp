import 'package:flutter/material.dart';
import '../../../shared/widgets/animations.dart';

class GameBottomBar extends StatelessWidget {
  const GameBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(
          0xFF161824,
        ).withValues(alpha: 0.9), // Dark matching theme
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionItem(Icons.mic_none, '语音', Colors.amber),
            _buildActionItem(Icons.description_outlined, '剧本', Colors.white),
            _buildActionItem(Icons.hub_outlined, '线索', Colors.white),
            _buildActionItem(Icons.card_giftcard, '礼物', const Color(0xFFE0647C)),
            _buildActionItem(Icons.lightbulb_outline, '技能', Colors.white),
            _buildActionItem(Icons.edit_note_outlined, '笔记', Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return PressScale(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color == Colors.white ? Colors.white70 : color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
