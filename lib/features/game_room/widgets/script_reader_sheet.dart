import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 剧本阅读弹层：个人剧本（仅本人可见）+ 公共剧本，支持分段阅读。
class ScriptReaderSheet extends StatefulWidget {
  const ScriptReaderSheet({super.key});

  @override
  State<ScriptReaderSheet> createState() => _ScriptReaderSheetState();
}

class _ScriptReaderSheetState extends State<ScriptReaderSheet> {
  int _tab = 0; // 0 = 个人剧本, 1 = 公共剧本

  /// 个人剧本段落：仅本人可见，含关键信息与隐瞒点。
  static const List<({String title, List<String> paras})> _personal = [
    (
      title: '一、身份',
      paras: [
        '你是作家『沈墨』，网络小说界的隐形操盘手，笔名为「暗夜书虫」。今晚受邀前往英格兰别墅参加「侦探文学之夜」，实则另有所图。',
      ],
    ),
    (
      title: '二、你的秘密',
      paras: [
        '你与死者『郑楠』曾是同一出版社的同事。三年前，他窃取了你的长篇手稿《南方旧案》的创意，改写后用「南山」的笔名发表，一夜爆红。',
        '你一直在搜集证据，想拿回属于你的名誉。你对他怀有深深的恨意，但你不希望任何人——包括的助手——知道你与他的纠葛。',
      ],
    ),
    (
      title: '三、案发当晚行动轨迹',
      paras: [
        '20:30 你抵达别墅，与管家寒暄后进入休息室。',
        '21:00 你以上卫生间为由离开单人座，实际前往书房方向查看。',
        '23:40 你听到一声闷响，随后管家呼喊。你返回现场时，郑楠已倒地。',
        '你藏起了一条属于你的、刻着「沈」字的钢笔，不希望被查出。',
      ],
    ),
    (
      title: '四、你必须隐瞒的事',
      paras: [
        '不要主动提及你与死者的过往仇怨。若有人问起，你声称与郑楠仅有一面之缘。',
        '你三小时内曾经接近过书房，若被质疑，编造「走错房间」的理由。',
      ],
    ),
  ];

  /// 公共剧本段落：全员可见。
  static const List<({String title, List<String> paras})> _public = [
    (
      title: '开场白',
      paras: [
        '英格兰郊外的别墅，一场名为「侦探文学之夜」的雅集正在举行。宾客皆是小说界的名流。',
      ],
    ),
    (
      title: '案发经过',
      paras: [
        '当晚 23:40，别墅书房传来一声闷响。管家推门发现，网络小说家『郑楠』头部受重创，倒在书桌前，已然气绝。',
        '警方封锁现场。书房门窗完好，无强行闯入痕迹，初步判断为熟人作案。',
      ],
    ),
    (
      title: '现场情况',
      paras: [
        '死者身后电脑屏幕停留在未保存的文档上，桌上一杯红茶尚且温热。地毯边沿散落几页稿纸。',
        '所有人被要求在别墅内等待逐一询问。凶手就在你们之中。',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sections = _tab == 0 ? _personal : _public;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
            // 标题栏
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  const Text(
                    '《暗杀网络小说家》',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab 切换
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(child: _tabItem(0, '个人剧本', _tab == 0)),
                    const SizedBox(width: 4),
                    Expanded(child: _tabItem(1, '公共剧本', _tab == 1)),
                  ],
                ),
              ),
            ),
            // 个人剧本红标提示
            if (_tab == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Icon(Icons.lock_outline, color: Color(0xFFFF8A80), size: 14),
                    SizedBox(width: 6),
                    Text(
                      '仅你可见 · 阅读完毕请销毁，勿向他人透露',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            // 内容
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                physics: const BouncingScrollPhysics(),
                itemCount: sections.length,
                itemBuilder: (context, i) {
                  final s = sections[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 3,
                              height: 14,
                              decoration: BoxDecoration(
                                color: _tab == 0
                                    ? const Color(0xFFFFB74D)
                                    : const Color(0xFF4DD0E1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              s.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        for (final p in s.paras)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              p,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(int index, String label, bool active) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _tab = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFAC5AF0) : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white60,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}