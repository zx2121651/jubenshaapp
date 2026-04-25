import 'package:flutter/material.dart';

class GameRoomScreen extends StatelessWidget {
  final String roomId;
  const GameRoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('游玩房间 - $roomId')),
      body: Center(child: Text('核心游玩模块：连麦、聊天、剧本阅读、搜证。房间ID: $roomId')),
    );
  }
}
