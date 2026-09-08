import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../shared/widgets/animations.dart';

class ClueBoardScreen extends StatefulWidget {
  final String roomId;
  const ClueBoardScreen({super.key, required this.roomId});

  @override
  State<ClueBoardScreen> createState() => _ClueBoardScreenState();
}

class _ClueBoardScreenState extends State<ClueBoardScreen> {
  static const _suspects = ['张林路', '爱丽丝', '李子明', '鹿鸣', '陈侦探'];
  static const _clues = [
    '时间线', '现场指纹', '一封遗书', '消失的凶器', '不在场证明',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14161F),
      appBar: AppBar(
        title: Text('推理白板 · ${widget.roomId}'),
        backgroundColor: const Color(0xFF14161F),
      ),
      body: Stack(
        children: [
          // 点阵背景
          CustomPaint(
            painter: _DotGridPainter(),
            size: Size.infinite,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    UIConstants.spacingLg,
                    UIConstants.spacingSm,
                    UIConstants.spacingLg,
                    UIConstants.spacingSm,
                  ),
                  child: Text(
                    '嫌疑人',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // 嫌疑人卡片
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.spacingLg,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: _suspects.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => Entrance(
                      delay: Duration(milliseconds: 80 + i * 50),
                      child: _SuspectCard(name: _suspects[i]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
                  child: Text(
                    '线索',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // 线索区（瀑布）
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      UIConstants.spacingLg,
                      UIConstants.spacingSm,
                      UIConstants.spacingLg,
                      100,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.9,
                    ),
                    itemCount: _clues.length,
                    itemBuilder: (context, i) => Entrance(
                      delay: Duration(milliseconds: 120 + i * 50),
                      child: _ClueCard(label: _clues[i]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuspectCard extends StatelessWidget {
  const _SuspectCard({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F212D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFA78BFA),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                String.fromCharCode(name.runes.first),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ClueCard extends StatelessWidget {
  const _ClueCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262836),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC24B).withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFFFFC24B),
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.05);
    const spacing = 24.0;
    var y = 0.0;
    while (y < size.height) {
      var x = 0.0;
      while (x < size.width) {
        canvas.drawCircle(Offset(x, y), 1, paint);
        x += spacing;
      }
      y += spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}