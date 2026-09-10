// App 冒烟测试：验证应用可正常构建渲染，底部导航 Tab 可切换，
// 并依次渲染详情页 / 游戏房 / 推理白板等二级页面。
//
// 注意：首页头像区含无限循环的 Breathe 动画，不能使用 pumpAndSettle，
// 因此这里用分段 pump 等待入场/翻页动画完成；任何 RenderFlex 溢出等
// 布局异常都会自动导致测试失败。
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jubensha_app/main.dart';
import 'package:jubensha_app/core/routing/app_router.dart';

void main() {
  testWidgets('App 冒烟测试：全部页面渲染 + Tab 切换', (WidgetTester tester) async {
    // 与应用真实入口（main() 中 runApp(ProviderScope(child: MyApp()))）保持一致。
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    // 等待首帧与各 Entrance 入场动画执行。
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));

    // 底部导航 5 项齐全（含中央「开始游戏」主按钮）。
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('剧本'), findsOneWidget);
    expect(find.text('开始游戏'), findsOneWidget);
    expect(find.text('消息'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);

    // 首页标志性元素：搜索入口。
    expect(find.text('搜索剧本 / 作者 / 标签'), findsOneWidget);

    // Tab 1：剧本（组局列表）。
    await tester.tap(find.text('剧本'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    // Tab 2：中央主按钮 → 弹出「开局准备」组局弹层。
    await tester.tap(find.text('开始游戏'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('开局准备'), findsOneWidget);
    // 关闭弹层，回到当前 Tab。
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    // Tab 3：消息。
    await tester.tap(find.text('消息'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    // 私信点进聊天详情页。
    await tester.tap(find.text('露水之情'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('对呀，玩了三年多剧本了～'), findsOneWidget);
    expect(find.text('输入消息…'), findsOneWidget);
    // 返回消息中心。
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    // Tab 4：我的，应有侦探等级卡。
    await tester.tap(find.text('我的'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('名侦探'), findsOneWidget);

    // 切回首页。
    await tester.tap(find.text('首页'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('搜索剧本 / 作者 / 标签'), findsOneWidget);

    // 二级页面：剧本详情。
    appRouter.go('/scripts/1');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));

    // 全局搜索：首页入口 → 搜索 → 结果 → 回退。
    appRouter.go('/');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
    appRouter.go('/search');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(find.byType(TextField).last, '恐怖');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('血色婚礼'), findsOneWidget);
    // 返回首页。
    appRouter.go('/');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));

    // 二级页面：游戏房。
    appRouter.go('/room/123');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('剧本阅读阶段'), findsOneWidget);
    // 阶段推进：搜证 → 讨论 → 投票。
    await tester.tap(find.text('下一阶段'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('搜证阶段'), findsOneWidget);
    // 剧本阅读可用：打开个人剧本并切换公共剧本。
    await tester.tap(find.text('剧本'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('《暗杀网络小说家》'), findsOneWidget);
    expect(find.text('仅你可见 · 阅读完毕请销毁，勿向他人透露'), findsOneWidget);
    await tester.ensureVisible(find.text('公共剧本'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('公共剧本'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('案发经过'), findsOneWidget);
    // 关闭剧本弹层。
    await tester.tap(find.byIcon(Icons.close).last);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('下一阶段'));
    await tester.pump(const Duration(milliseconds: 400));
    // 投票弹层可用：选中玩家后可确认。
    await tester.tap(find.text('投票'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.byKey(const ValueKey('vote-张林路')));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byKey(const ValueKey('vote-张林路')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('确认投票'), findsOneWidget);
    // 关闭投票弹层。
    await tester.tap(find.text('确认投票'));
    await tester.pump(const Duration(milliseconds: 400));

    // 线索板可用：展开线索 → 搜证收集 → 计数更新。
    await tester.tap(find.text('线索'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('线索板'), findsOneWidget);
    expect(find.text('已搜证 0/8'), findsOneWidget);
    // 展开第一条线索并搜证。
    await tester.ensureVisible(find.text('染血的台灯'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('染血的台灯'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.ensureVisible(find.text('搜证'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('搜证'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('已搜证 1/8'), findsOneWidget);
    expect(find.text('已搜证'), findsOneWidget);
    // 关闭线索板（点击遮罩层空白处）。
    await tester.tapAt(const Offset(40, 40));
    await tester.pump(const Duration(milliseconds: 400));
    // 等待投票 Snackbar 完全消退（含退场动画）避免遮挡底部栏。
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    // 二次确认底部栏「笔记」可被点击，防止残留 Snackbar 遮挡。
    await tester.ensureVisible(find.text('笔记'));
    await tester.pump(const Duration(milliseconds: 200));

    // 推理笔记可用：查看已有记录、新增一条。
    await tester.tap(find.text('笔记'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('推理笔记'), findsOneWidget);
    expect(find.text('3 条记录'), findsOneWidget);
    // 新增一条笔记。
    await tester.enterText(find.byType(TextField).last, '时间线：来电与遇害仅隔 1 分钟');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('4 条记录'), findsOneWidget);
    expect(find.text('时间线：来电与遇害仅隔 1 分钟'), findsOneWidget);
    // 关闭笔记弹层。
    await tester.tapAt(const Offset(40, 40));
    await tester.pump(const Duration(milliseconds: 400));

    // 语音房可用：显示当事人、切换闭麦。
    await tester.tap(find.text('语音'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('语音房'), findsOneWidget);
    expect(find.text('爱丽丝 正在发言'), findsOneWidget);
    expect(find.text('按住说话'), findsOneWidget);
    await tester.ensureVisible(find.text('闭麦'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('闭麦'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('按住说话'), findsOneWidget);
    // 关闭语音房弹层。
    await tester.tapAt(const Offset(40, 40));
    await tester.pump(const Duration(milliseconds: 400));

    // 二级页面：推理白板。
    appRouter.go('/clue-board/123');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
  });
}
