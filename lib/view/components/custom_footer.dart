import 'package:flutter/material.dart';

/// アイコンとラベルを縦に並べ、選択時にカプセル状の背景で囲むカスタムフッター。
/// 画面下部に浮かせて配置するフローティングデザインを採用しています。
class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  /// 現在選択されているタブのインデックス
  int _selectedIndex = 0;

  /// フッターに表示するアイコンとラベルの定義
  final List<Map<String, dynamic>> _items = [
    {'icon': Icons.home, 'label': 'ホーム'},
    {'icon': Icons.account_circle, 'label': '会員証'},
    {'icon': Icons.calendar_month, 'label': 'カレンダー'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 画面下部から浮かせるためのマージンと角丸の設定
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (index) {
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              // 選択時にアイコンとテキストをまとめて包むオレンジのカプセル
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _items[index]['icon'],
                    size: 28,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _items[index]['label'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
