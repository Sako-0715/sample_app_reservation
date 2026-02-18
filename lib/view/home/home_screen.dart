import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app_reservation/view/components/custom_tab_bar.dart';
import 'package:sample_app_reservation/view/home/shop_info_view.dart';
import 'package:sample_app_reservation/viewmodel/shop_info_view_model.dart';

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
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => ShopInfoViewModel()..loadShopInfo(),
              child: const ShopInfoView(),
            ),

            const Center(child: Text('お得なクーポンやメニュー一覧がここに入ります')),
          ],
        ),
      ),
    );
  }
}
