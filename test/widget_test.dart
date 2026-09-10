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

    // 二级页面：推理白板。
    appRouter.go('/clue-board/123');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
  });
}
