import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:jubensha_app/features/home/widgets/sticky_tab_bar.dart';
import 'package:jubensha_app/features/home/widgets/king_kong_grid.dart';
import 'package:jubensha_app/features/home/widgets/home_header.dart';
import 'package:jubensha_app/shared/widgets/custom_bottom_nav_bar.dart';

void main() {
  testWidgets('HomeHeader renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HomeHeader())));
    expect(find.text('北京市'), findsOneWidget);
    expect(find.text('搜索剧本/门店/玩家'), findsOneWidget);
  });

  testWidgets('KingKongGrid renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: KingKongGrid())));
    expect(find.text('海量剧本'), findsOneWidget);
    expect(find.text('发现门店'), findsOneWidget);
    expect(find.text('全部'), findsOneWidget);
  });

  testWidgets('StickyTabBar renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: StickyTabBar())));
    expect(find.text('关注'), findsOneWidget);
    expect(find.text('推荐'), findsOneWidget);
    expect(find.text('附近'), findsOneWidget);
  });

  testWidgets('CustomBottomNavBar renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, onTap: (_) {}))));
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('圈子'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);
  });
}
