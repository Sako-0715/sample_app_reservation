import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app_reservation/view/home/shop_info_view.dart';
import 'package:sample_app_reservation/viewmodel/shop_info_view_model.dart';
import '../components/custom_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お店の名前'),
        // bottom（タブバー）を削除しました
      ),
      //ShopInfoViewのみを表示
      body: ChangeNotifierProvider(
        create: (context) => ShopInfoViewModel()..loadShopInfo(),
        child: const ShopInfoView(),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
