import 'package:flutter/material.dart';
import 'package:sample_app_reservation/view/components/image_slider.dart';

class ShopInfoView extends StatelessWidget {
  const ShopInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // 1. メインのスライダー（店舗の全体像など）
          const ImageSlider(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // セクションタイトル
                const Text(
                  '当店の特徴PickUp',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 2. 特徴用のスライダーを再配置
                const ImageSlider(),

                const SizedBox(height: 12),

                // 3. 特徴の説明テキスト
                const Text(
                  '厳選された旬の食材を使用し、職人が一つひとつ丁寧に仕上げています。落ち着いた空間で、至福のひとときをお過ごしください。',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5, // 行間を少し広げると読みやすい
                  ),
                ),

                const SizedBox(height: 32), // セクション間の余白
                const Divider(), // 区切り線を入れると情報が整理されます
                const SizedBox(height: 16),

                // 基本情報セクション
                const Text(
                  '基本情報',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                buildDetailRow(Icons.location_on, '住所', '福岡県福岡市中央区...'),
                buildDetailRow(Icons.access_time, '営業時間', '10:00 〜 20:00'),
                buildDetailRow(Icons.phone, '電話番号', '092-123-4567'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String label, String content) {
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
