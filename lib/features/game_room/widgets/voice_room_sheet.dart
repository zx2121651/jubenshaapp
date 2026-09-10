import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 语音房弹层：显示发言人、玩家麦克风状态，支持开麦/闭麦与按住说话。
class VoiceRoomSheet extends StatefulWidget {
  const VoiceRoomSheet({super.key});

  @override
  State<VoiceRoomSheet> createState() => _VoiceRoomSheetState();
}

class _VoiceRoomSheetState extends State<VoiceRoomSheet> {
  /// 玩家麦克风开关（true = 已开麦）。
  final Map<String, bool> _muted = {
    '张林路': true,
    '爱丽丝': true,
    '李子明': false,
    '鹿鸣': true,
    '胡云闪': true,
    '陈侦探': true,
    '孙允珠': false,
    '李子航': true,
    '吴晓波': true,
    '王华丽': true,
  };

  /// 当前正在发言的玩家（用于展示轮播发言人）。
  final String _speaking = '爱丽丝';

  /// 按住说话：按压态。
  bool _holding = false;

  static const List<String> _players = [
    '张林路', '爱丽丝', '李子明', '鹿鸣', '胡云闪',
    '陈侦探', '孙允珠', '李子航', '吴晓波', '王华丽',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Color(0xFF161824),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // 顶部把手
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            // 标题
            const Text(
              '语音房',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            // 当前发言人
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Container(
                key: ValueKey(_speaking),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4DD0E1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4DD0E1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.graphic_eq,
                      color: Color(0xFF4DD0E1),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_speaking 正在发言',
                      style: const TextStyle(
                        color: Color(0xFF4DD0E1),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 玩家列表
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.4,
                ),
                itemCount: _players.length,
                itemBuilder: (context, i) {
                  final name = _players[i];
                  final isOwner = name == '爱丽丝';
                  final muted = _muted[name] ?? true;
                  return _micTile(name, muted, isOwner);
                },
              ),
            ),
            // 底部控制
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 闭麦/开麦
                  GestureDetector(
                    onTap: () => setState(() {
                      HapticFeedback.selectionClick();
                      _muted['爱丽丝'] = !(_muted['爱丽丝'] ?? true);
                    }),
                    child: _roundControl(
                      Icons.mic_off,
                      '闭麦',
                      muted: _muted['爱丽丝'] ?? true,
                    ),
                  ),
                  // 按住说话
                  GestureDetector(
                    onTapDown: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _holding = true);
                    },
                    onTapUp: (_) => setState(() => _holding = false),
                    onTapCancel: () => setState(() => _holding = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: 120,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _holding
                              ? const [Color(0xFFFF8A80), Color(0xFFE0647C)]
                              : const [Color(0xFF9B7BFF), Color(0xFF6C3FDC)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: _holding
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFFF8A80)
                                      .withValues(alpha: 0.5),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _holding
                                ? Icons.graphic_eq
                                : Icons.mic,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _holding ? '说话中…' : '按住说话',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 信息
                  _roundControl(Icons.info_outline, '详情', muted: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 单个玩家麦克风磁贴。
  Widget _micTile(String name, bool muted, bool isOwner) {
    final speaking = name == _speaking;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: speaking
            ? const Color(0xFF4DD0E1).withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: speaking ? const Color(0xFF4DD0E1) : Colors.white12,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isOwner
                ? const Color(0xFFAC5AF0)
                : Colors.white.withValues(alpha: 0.1),
            child: Text(
              name.characters.first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  muted ? '已闭麦' : '开麦中',
                  style: TextStyle(
                    color: muted
                        ? Colors.white38
                        : const Color(0xFF4DD0E1),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            muted
                ? (speaking ? Icons.mic_off : Icons.mic_none)
                : Icons.mic,
            color: speaking
                ? const Color(0xFF4DD0E1)
                : (muted ? Colors.white38 : const Color(0xFF4DD0E1)),
            size: 18,
          ),
        ],
      ),
    );
  }

  /// 圆形小控制按钮。
  Widget _roundControl(IconData icon, String label, {required bool muted}) {
    final accent = muted ? const Color(0xFFFF8A80) : const Color(0xFF4DD0E1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 1),
          ),
          child: Icon(icon, color: accent, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}