/// 店舗の地図表示に必要な情報をまとめたモデル
/// - imagePath: 地図画像のURLやローカルパス
/// - shopName: 店舗名（地図上に表示するため）
class ShopMapModel {
  final String imagePath;
  final String shopName;

  ShopMapModel({required this.imagePath, required this.shopName});
}
