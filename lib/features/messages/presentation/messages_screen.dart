import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/gradient_avatar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _isNotices = false;

  static const _conversations = [
    {'user': '露水之情', 'msg': '我带你玩吧，拉我进你那车', 'time': '13:42', 'unread': 2},
    {'user': '草莓甜心派', 'msg': 'HI,我刚玩这个软件，求带！！', 'time': '12:10', 'unread': 1},
    {'user': '张林路', 'msg': '[图片] 剧本攻略整理好了', 'time': '昨天', 'unread': 0},
    {'user': '陈侦探', 'msg': '今晚有空一起打本吗？', 'time': '周一', 'unread': 0},
  ];

  static const _notices = [
    {'title': '系统通知', 'msg': '你的剧本《血色婚礼》已通过审核，快去开团吧～', 'time': '10:20', 'unread': 1},
    {'title': '活动提醒', 'msg': '大侦探三期活动已开始，完成30天任务领永久装扮！', 'time': '08:00', 'unread': 1},
    {'title': '金币到账', 'msg': '你收到 50 金币打赏。', 'time': '昨天', 'unread': 0},
  ];

  @override
  Widget build(BuildContext context) {
    final data = _isNotices ? _notices : _conversations;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                UIConstants.spacingLg,
                UIConstants.spacingLg,
                UIConstants.spacingLg,
                8,
              ),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble, color: AppTheme.primary, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '消息中心',
                    style: TextStyle(
                      color: AppTheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: UIConstants.spacingLg),
              child: Container(
                width: 168,
                height: 36,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    _seg('私信', !_isNotices, () => setState(() => _isNotices = false)),
                    _seg('通知', _isNotices, () => setState(() => _isNotices = true)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  UIConstants.spacingLg,
                  UIConstants.spacingSm,
                  UIConstants.spacingLg,
                  100,
                ),
                itemCount: data.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  color: Colors.white10,
                ),
                itemBuilder: (context, index) => Entrance(
                  delay: Duration(milliseconds: 50 + index * 50),
                  offset: const Offset(0, 12),
                  child: PressScale(
                    pressedScale: 0.96,
                    child: _isNotices
                        ? _NoticeTile(item: data[index])
                        : GestureDetector(
                            onTap: () => context.push(
                              '/chat/${data[index]['user']}',
                            ),
                            child: _ConversationTile(item: data[index]),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seg(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.easeOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : AppTheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final unread = item['unread'] as int;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          GradientAvatar(text: item['user'] as String, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['user'] as String,
                  style: const TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['msg'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['time'] as String,
                style: const TextStyle(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 6),
              if (unread > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final unread = item['unread'] as int;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.campaign, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['msg'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['time'] as String,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              if (unread > 0) ...[
                const SizedBox(height: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}