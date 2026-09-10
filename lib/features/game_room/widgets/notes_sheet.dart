import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 推理笔记弹层：记录本局疑点 / 灵感，可新增、删除。
class NotesSheet extends StatefulWidget {
  const NotesSheet({super.key});

  @override
  State<NotesSheet> createState() => _NotesSheetState();
}

class _NotesSheetState extends State<NotesSheet> {
  final _controller = TextEditingController();
  final List<String> _notes = [
    '管家 23:47 来电，随后再无动静，时间线可疑',
    '施发烟灰「哈宾娜」牌，只有受邀编辑习惯一致',
    '保险柜内遗嘱复印件墨迹仍新，像是刚放进去',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() => _notes.insert(0, text));
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _remove(int index) {
    HapticFeedback.lightImpact();
    setState(() => _notes.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Color(0xFF151722),
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
            // 标题 + 计数
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Icon(
                    Icons.edit_note,
                    color: Color(0xFFFFB74D),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '推理笔记',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_notes.length} 条记录',
                      style: const TextStyle(
                        color: Color(0xFFFFB74D),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 输入框 + 添加按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: '记录一条疑点或灵感…',
                        hintStyle: const TextStyle(color: Colors.white30),
                        prefixIcon: const Icon(
                          Icons.psychology_outlined,
                          color: Colors.white38,
                          size: 20,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.06),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _add,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB74D), Color(0xFFE0862B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB74D).withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black87,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 笔记列表
            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text(
                        '暂无私享笔记，记录灵光一现',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _notes.length,
                      itemBuilder: (context, i) {
                        final note = _notes[i];
                        return _NoteCard(
                          index: i,
                          note: note,
                          onDelete: () => _remove(i),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 单条笔记卡片。
class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.index,
    required this.note,
    required this.onDelete,
  });

  final int index;
  final String note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB74D).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Color(0xFFFFB74D),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          GestureDetector(
            key: ValueKey('note-del-$index'),
            onTap: onDelete,
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white30,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}