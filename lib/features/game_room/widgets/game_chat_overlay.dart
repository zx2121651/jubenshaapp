import 'package:flutter/material.dart';

class GameChatOverlay extends StatelessWidget {
  const GameChatOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fit content
        children: [
          // System message 1
          Row(
            children: const [
              Icon(Icons.sports_esports, color: Colors.white70, size: 14),
              SizedBox(width: 4),
              Text(
                '草莓甜心派 ',
                style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
              ),
              Text(
                '公开了线索',
                style: TextStyle(color: Colors.amber, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // System message 2
          const Text(
            '系统: 游戏已开始',
            style: TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
          ),
          const SizedBox(height: 4),
          // User message 1
          Row(
            children: const [
              Icon(Icons.face, color: Colors.pinkAccent, size: 14),
              SizedBox(width: 4),
              Text(
                '草莓甜心派: ',
                style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
              ),
              Expanded(
                child: Text(
                  'HI,我刚玩这个软件，求带！！',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // User message 2
          const Text(
            '露水之情: 我带你玩吧',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
