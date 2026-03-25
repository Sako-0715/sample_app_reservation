import 'package:flutter/material.dart';

/// 店舗情報とクーポン・メニューを切り替える、角丸カプセルデザインのカスタムタブバー。
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({super.key});

  /// タブに表示するラベルのリスト
  static const List<String> tempTabLabels = ['店舗情報', 'クーポン・メニュー'];

  @override
  Widget build(BuildContext context) {
    return Container(
      // タブ全体の背景色と角丸の設定
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        // 選択中のタブをオレンジ色のカプセルで覆うデザイン設定
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.orange[700],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info, size: 18),
                SizedBox(width: 8),
                Text('店舗情報', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Tab(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_number, size: 18),
                SizedBox(width: 8),
                Text(
                  'クーポン・メニュー',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // コンテナのマージン（上下8pxずつ）を考慮した高さの定義
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
