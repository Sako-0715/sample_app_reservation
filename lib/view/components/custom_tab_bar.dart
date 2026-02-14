import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({super.key});

  static const List<String> tempTabLabels = ['店舗情報', 'クーポン・メニュー'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // タブ背景色
        color: Colors.grey[200],
        // 角丸
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        // 選択中のタブのデザイン
        indicator: BoxDecoration(
          // 選択中の角丸
          borderRadius: BorderRadius.circular(50),
          // 選択中の背景色
          color: Colors.orange[700],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        // 選択中の文字・アイコン色
        labelColor: Colors.white,
        // 未選択時の文字・アイコン色
        unselectedLabelColor: Colors.grey[600],
        // 境界線や影を消す設定
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

  // Containerのmargin分（上下8pxずつ=16px）を高さに加算
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
