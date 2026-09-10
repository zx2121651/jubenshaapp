import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/widgets/animations.dart';

/// 底部操作栏：语音 / 剧本 / 线索 / 投票 / 礼物 / 笔记。
/// 交互化：线索与投票回调生效，其余给出轻反馈。
class GameBottomBar extends StatelessWidget {
  const GameBottomBar({super.key, this.onVote, this.onClue, this.onScript});

  final VoidCallback? onVote;
  final VoidCallback? onClue;
  final VoidCallback? onScript;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161824).withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            _action(Icons.mic_none, '语音', Colors.amber, onTap: () {
              _toast(context, '麦克风状态：默认闭麦，点击发言');
            }),
            _action(Icons.description_outlined, '剧本', Colors.white, onTap: onScript ?? () {
              _toast(context, '剧本保留篇目：暗杀网络小说家');
            }),
            _action(Icons.hub_outlined, '线索', Colors.white, onTap: onClue),
            _voteAction(context),
            _action(Icons.card_giftcard, '礼物', const Color(0xFFE0647C), onTap: () {
              _toast(context, '礼物会场已开启，挑一份吧');
            }),
            _action(Icons.edit_note_outlined, '笔记', Colors.white, onTap: () {
              _toast(context, '本局笔记：共有 4 条记录');
            }),
          ],
        ),
      ),
    );
  }

  /// 中央「投票」CTA。
  Widget _voteAction(BuildContext context) {
    return GestureDetector(
      onTap: onVote,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9B7BFF), Color(0xFF6C3FDC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFAC5AF0).withValues(alpha: 0.5),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.how_to_vote, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 4),
          const Text(
            '投票',
            style: TextStyle(
              color: Color(0xFFB388FF),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return PressScale(
      pressedScale: 0.9,
      onTap: onTap,
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

  void _toast(BuildContext context, String msg) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2A2C3A),
      ),
    );
  }
}