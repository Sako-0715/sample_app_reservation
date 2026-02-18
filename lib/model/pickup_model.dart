/// ピックアップ（カード型UI用）のデータモデル
class PickupModel {
  final String title;
  final String imageUrl;
  final String content;
  final DateTime? publishedAt;
  final DateTime? revisedAt;

  PickupModel({
    required this.title,
    required this.imageUrl,
    required this.content,
    this.publishedAt,
    this.revisedAt,
  });

  /// microCMSのJSONからPickupModelを生成
  factory PickupModel.fromJson(Map<String, dynamic> json) {
    // 画像URLの取得と圧縮パラメータの付与
    final imageField = json['pickup_image'] as Map<String, dynamic>?;
    final rawUrl = imageField?['url'] as String? ?? '';

    // 「転送量節約」（WebP化・リサイズ・画質調整）
    final optimizedImageUrl =
        rawUrl.isNotEmpty ? '$rawUrl?w=800&q=75&fm=webp' : '';

    return PickupModel(
      title: json['title'] as String? ?? '',
      imageUrl: optimizedImageUrl,
      content: json['content'] as String? ?? '',
      publishedAt:
          json['publishedAt'] != null
              ? DateTime.parse(json['publishedAt'] as String)
              : null,
      revisedAt:
          json['revisedAt'] != null
              ? DateTime.parse(json['revisedAt'] as String)
              : null,
    );
  }

  /// デバッグ用
  @override
  String toString() => 'PickupModel(title: $title)';
}
