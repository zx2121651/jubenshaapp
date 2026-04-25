import 'package:flutter/material.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('大厅组局')),
      body: const Center(child: Text('这里是组局与匹配模块：大厅/同城/创建房间')),
    );
  }
}
