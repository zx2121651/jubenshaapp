import 'package:flutter/material.dart';

class SquareScreen extends StatelessWidget {
  const SquareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('剧本广场')),
      body: const Center(child: Text('这里是社交与社区模块：发帖、找队友')),
    );
  }
}
