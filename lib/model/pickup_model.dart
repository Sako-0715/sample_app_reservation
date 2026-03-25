import 'package:sample_app_reservation/utils/string_utils.dart';

/// ピックアップ（カード型UI用）のデータモデル
/// title: ピックアップのタイトル
/// imageUrl: ピックアップの画像URL（最適化されたURLを保持）
/// content: ピックアップの内容（HTML形式）遷移先で使用
/// displayDescription: contentからHTMLタグを除去したテキスト（ホーム画面で使用）
/// publishedAt: 公開日時
/// revisedAt: 更新日時
class PickupModel {
  final String title;
  final String imageUrl;
  final String content;
  final String displayDescription;
  final DateTime? publishedAt;
  final DateTime? revisedAt;

  PickupModel({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.displayDescription,
    this.publishedAt,
    this.revisedAt,
  });

  /// microCMSのJSONデータから[PickupModel]インスタンスを生成します。
  factory PickupModel.fromJson(Map<String, dynamic> json) {
    final imageField = json['pickup_image'] as Map<String, dynamic>?;
    final rawUrl = imageField?['url'] as String? ?? '';
    final rawContent = json['content'] as String? ?? '';

    // WebP変換、リサイズ、画質調整による転送量の最適化処理
    final optimizedImageUrl =
        rawUrl.isNotEmpty ? '$rawUrl?w=800&q=75&fm=webp' : '';

    return PickupModel(
      title: json['title'] as String? ?? '',
      imageUrl: optimizedImageUrl,
      content: rawContent,
      displayDescription: StringUtils.stripHtml(rawContent),
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

  @override
  String toString() => 'PickupModel(title: $title)';
}
