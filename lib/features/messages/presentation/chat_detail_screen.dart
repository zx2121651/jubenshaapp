import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/gradient_avatar.dart';

/// 单条私信
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMine,
    this.time = '',
  });

  final String text;
  final bool isMine;
  final String time;
}

/// 私信聊天详情页：气泡对话 + 底部输入栏。
/// 对标国内剧本杀 App 的私聊体验，支持发送后可继续对话。
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.userName});

  final String userName;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();

  late final List<ChatMessage> _messages = [
    const ChatMessage(text: '在吗？听说你是老手了', isMine: false, time: '13:41'),
    const ChatMessage(text: '对呀，玩了三年多剧本了～', isMine: true, time: '13:41'),
    const ChatMessage(text: '那太好了，我这周末想组个硬核车', isMine: false, time: '13:42'),
    const ChatMessage(
        text: '我带你玩吧，拉我进你那车，保你体验拉满 😎',
        isMine: false,
        time: '13:42'),
    const ChatMessage(text: '好嘞，我到群里喊人', isMine: true, time: '13:43'),
  ];

  // 是否显示“对方正在输入”气泡动画
  bool _typing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isMine: true));
    });
    _controller.clear();
    _controller.removeListener(_onTypingChanged);
    _controller.addListener(_onTypingChanged);

    // 模拟对方回信，形成对话闭环。
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _typing = true);
      Future<void>.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        setState(() {
          _typing = false;
          _messages.add(const ChatMessage(
            text: '收到！这就帮你把位置留好，到时候直接来👌',
            isMine: false,
          ));
        });
      });
    });
  }

  void _onTypingChanged() {
    // 文本框内容变化时轻触反馈（可选，避免每次 rebuild）。
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GradientAvatar(text: widget.userName, size: 32),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                const _OnlineDot(),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            itemCount: _messages.length + (_typing ? 1 : 0),
            itemBuilder: (context, i) {
              if (_typing && i == 0) return const _TypingBubble();
              // reverse 列表：索引 0 为最新消息。
              final m = _typing
                  ? _messages[_messages.length - 1 - (i - 1)]
                  : _messages[_messages.length - 1 - i];
              return Entrance(
                delay: const Duration(milliseconds: 40),
                offset: const Offset(0, 8),
                child: _MessageBubble(
                  message: m,
                  isLast: i == 0 || (i == 1 && _typing),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildInputBar(),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: AppTheme.onSurfaceVariant, size: 26),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppTheme.onSurface),
                  cursorColor: AppTheme.primary,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(
                    hintText: '输入消息…',
                    hintStyle: TextStyle(color: AppTheme.onSurfaceVariant),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                _send();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B7BFF), Color(0xFF6C3FDC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 在线状态点（绿色呼吸）。
class _OnlineDot extends StatefulWidget {
  const _OnlineDot();

  @override
  State<_OnlineDot> createState() => _OnlineDotState();
}

class _OnlineDotState extends State<_OnlineDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Opacity(
        opacity: 0.5 + _c.value * 0.5,
        child: const Text(
          '在线',
          style: TextStyle(
            color: Color(0xFF34C77B),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// 对方“正在输入”气泡动画。
class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: const _ThreeDots(),
      ),
    );
  }
}

class _ThreeDots extends StatefulWidget {
  const _ThreeDots();

  @override
  State<_ThreeDots> createState() => _ThreeDotsState();
}

class _ThreeDotsState extends State<_ThreeDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: AppTheme.onSurfaceVariant.withValues(
                    alpha: 0.4 + _dot(i),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        );
      },
    );
  }

  double _dot(int i) {
    // 依次错峰起伏。
    return (_c.value * 2 - i * 0.33).clamp(0.0, 0.5) * (i % 2 == 0 ? 0.8 : 1.0);
  }
}

/// 单条消息气泡。
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, this.isLast = false});

  final ChatMessage message;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            decoration: BoxDecoration(
              color: mine ? AppTheme.primary : AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(mine ? 16 : 4),
                topRight: Radius.circular(mine ? 4 : 16),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: mine ? Colors.white : AppTheme.onSurface,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          if (message.time.isNotEmpty)
            Text(
              message.time,
              style: const TextStyle(color: Colors.white30, fontSize: 10),
            ),
        ],
      ),
    );
  }
}