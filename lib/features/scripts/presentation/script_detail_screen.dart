import 'package:flutter/material.dart';

class ScriptDetailScreen extends StatelessWidget {
  final String scriptId;
  const ScriptDetailScreen({super.key, required this.scriptId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('剧本详情 - $scriptId')),
      body: Center(child: Text('剧本详情页，ID: $scriptId\n展示售价、作者、评价、发车入口')),
    );
  }
}
