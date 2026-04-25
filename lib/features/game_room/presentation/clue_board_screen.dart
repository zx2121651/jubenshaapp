import 'package:flutter/material.dart';

class ClueBoardScreen extends StatelessWidget {
  final String roomId;
  const ClueBoardScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('推理案件板 - $roomId')),
      body: Center(child: Text('无界白板：拖拽嫌疑人、线索，连线整理逻辑。房间ID: $roomId')),
    );
  }
}
