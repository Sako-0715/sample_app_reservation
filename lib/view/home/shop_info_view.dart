import 'package:flutter/material.dart';
import 'package:sample_app_reservation/view/components/image_slider.dart';

class ShopInfoView extends StatelessWidget {
  const ShopInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // スクロール
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 上のcomponetsとの余白
          const SizedBox(height: 16),
          // スライダー画像を配置
          const ImageSlider(),

          // 画像下の情報
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '店舗名：サンプルカフェ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // ここから住所や営業時間を並べる
                _buildDetailRow(Icons.location_on, '住所', '福岡県福岡市中央区...'),
                _buildDetailRow(Icons.access_time, '営業時間', '10:00 〜 20:00'),
                _buildDetailRow(Icons.phone, '電話番号', '092-123-4567'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 情報を並べるための便利な共通パーツ
  Widget _buildDetailRow(IconData icon, String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}
