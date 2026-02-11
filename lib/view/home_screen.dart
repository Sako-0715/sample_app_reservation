import 'package:flutter/material.dart';
import 'package:sample_app_reservation/view/components/tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. DefaultTabControllerでScaffoldを包む（lengthはタブの数）
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('お店の名前'), // 実際は店舗名など
          // 2. 自作したHomeTabBarを配置
          bottom: const HomeTabBar(),
        ),
        // 3. タブの中身を表示するエリア
        body: const TabBarView(
          children: [
            // 店舗情報　店舗画像や一押しな商品等の画像を掲載
            Center(child: Text('店舗の住所や営業時間がここに入ります')),

            // 「クーポン・メニュー」 クーポンでさらにタブで表示 すべて　初回クーポン 2回目以降　メニュー
            Center(child: Text('お得なクーポンやメニュー一覧がここに入ります')),
          ],
        ),
      ),
    );
  }
}
