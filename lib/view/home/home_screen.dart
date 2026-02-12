import 'package:flutter/material.dart';
import 'package:sample_app_reservation/view/components/custom_tab_bar.dart';
import 'package:sample_app_reservation/view/home/shop_info_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('お店の名前'),
          bottom: const CustomTabBar(),
        ),
        body: const TabBarView(
          children: [
            // 左タブ店舗情報
            ShopInfoView(),
            // 右タブ（まだ未作成ならとりあえずCenterでOK）
            Center(child: Text('お得なクーポンやメニュー一覧がここに入ります')),
          ],
        ),
      ),
    );
  }
}
