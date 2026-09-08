import 'package:flutter/material.dart';
import '../../shared/widgets/animations.dart';

class GameChatOverlay extends StatelessWidget {
  const GameChatOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withValues(alpha: 0.62), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Entrance(
            offset: Offset(0, 10),
            child: Row(
              children: [
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
          ),
          SizedBox(height: 4),
          Entrance(
            delay: Duration(milliseconds: 140),
            offset: Offset(0, 10),
            child: Text(
              '系统: 游戏已开始',
              style: TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
            ),
          ),
          SizedBox(height: 4),
          Entrance(
            delay: Duration(milliseconds: 260),
            offset: Offset(0, 10),
            child: Row(
              children: [
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
          ),
          SizedBox(height: 4),
          Entrance(
            delay: Duration(milliseconds: 380),
            offset: Offset(0, 10),
            child: Text(
              '露水之情: 我带你玩吧',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}