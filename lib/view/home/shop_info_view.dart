import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app_reservation/view/components/image_slider.dart';
import 'package:sample_app_reservation/view/components/card.dart';
import '../../viewmodel/shop_info_view_model.dart';

class ShopInfoView extends StatelessWidget {
  const ShopInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModelを監視
    final viewModel = context.watch<ShopInfoViewModel>();
    final shop = viewModel.shop;

    // 読み込み中
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // エラー時
    if (viewModel.errorMessage != null) {
      return Center(child: Text('Error: ${viewModel.errorMessage}'));
    }

    // データがない場合
    if (shop == null) {
      return const Center(child: Text('店舗情報が見つかりません'));
    }

    // PickupModel を CardItem に変換（タイトルのみ表示）
    final List<CardItem> pickupItems =
        viewModel.pickups.map((pickup) {
          return CardItem(
            title: pickup.title,
            description: null, // ここをnullにすることで、contentの内容を表示させない
            imageUrl: pickup.imageUrl,
            onTap: () {
              // タップ時の処理　遷移処理をここで書く
            },
          );
        }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // 1. メインのスライダー
          ImageSlider(imageUrls: shop.mainImages),

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

                // 特徴カードカルーセル（タイトルのみのカードを表示）
                if (pickupItems.isNotEmpty)
                  CardCarousel(
                    items: pickupItems,
                    cardHeight: 200, // タイトルだけなので高さを少し抑えても綺麗です
                  )
                else
                  ImageSlider(imageUrls: shop.featureImages, height: 180),

                const SizedBox(height: 12),

                // 3. 特徴の説明テキスト（店舗自体の説明）
                Text(
                  shop.description ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                // 基本情報セクション
                const Text(
                  '基本情報',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                buildDetailRow(Icons.location_on, '住所', shop.address),
                buildDetailRow(Icons.access_time, '営業時間', shop.openingHours),
                buildDetailRow(Icons.phone, '電話番号', shop.phone),
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
