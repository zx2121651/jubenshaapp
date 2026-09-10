import 'package:flutter/material.dart';

/// 顶部信息头：房间信息 + 阶段进度 + 阶段推进按钮。
class GameRoomHeader extends StatelessWidget {
  const GameRoomHeader({
    super.key,
    required this.stageIndex,
    required this.stageCount,
    required this.stageLabel,
    required this.stageColor,
    this.onNextStage,
  });

  final int stageIndex;
  final int stageCount;
  final String stageLabel;
  final Color stageColor;
  final VoidCallback? onNextStage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // 顶部小状态行（房间号 / WiFi / 电量）
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  '房间:13743742',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(width: 8),
                Icon(Icons.wifi, color: Colors.greenAccent, size: 14),
                SizedBox(width: 4),
                Icon(Icons.battery_full, color: Colors.greenAccent, size: 14),
              ],
            ),
            const SizedBox(height: 8),
            // 主信息块
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // 左侧信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            color: stageColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text(stageLabel),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '暗杀网络小说家...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 阶段进度点
                            for (var i = 0; i < stageCount; i++)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.only(right: 4),
                                width: i <= stageIndex ? 14 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: i <= stageIndex
                                      ? stageColor
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 右侧图标与按钮
                  Row(
                    children: [
                      const Icon(Icons.volume_up, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Icon(Icons.settings, color: Colors.white, size: 24),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onNextStage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFAC5AF0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            stageIndex + 1 >= stageCount ? '重开一局' : '下一阶段',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 副标题药丸
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '英格兰别墅内',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.access_time, color: Colors.amber, size: 12),
                    SizedBox(width: 4),
                    Text(
                      '300s',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}