/// 店舗情報のデータモデル
class CarouselModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String openingHours;
  final String? description;
  final List<String> mainImages;
  final List<String> featureImages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CarouselModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.openingHours,
    this.description,
    this.mainImages = const [],
    this.featureImages = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// microCMSのJSONレスポンスからCarouselModelを生成
  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      // オブジェクト形式で id が無い場合は 'single_object' をデフォルトにする
      id: json['id'] as String? ?? 'single_object',

      // フィールドIDがキャメル/スネークどちらでも対応できるように定義
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      openingHours:
          (json['openingHours'] ?? json['opening_hours']) as String? ?? '',
      description: json['description'] as String?,

      // 画像リストのパース（'image' または 'main_images' から取得）
      mainImages: _parseImageList(json['image'] ?? json['main_images']),
      featureImages: _parseImageList(json['feature_images']),

      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  /// 画像リストをパースするヘルパーメソッド
  static List<String> _parseImageList(dynamic imageData) {
    if (imageData == null) return [];
    // 圧縮用のパラメータ（横幅800px、画質75%、WebP形式に変換）
    const compressionParams = '?w=800&q=75&fm=webp';
    if (imageData is List) {
      return imageData
          .map((item) {
            String url = '';
            if (item is Map<String, dynamic>) {
              url = item['url'] as String? ?? '';
            } else {
              url = item.toString();
            }
            return url.isNotEmpty ? '$url$compressionParams' : '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'opening_hours': openingHours,
      'description': description,
      'main_images': mainImages,
      'feature_images': featureImages,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CarouselModel(id: $id, name: $name, mainImages: ${mainImages.length}件)';
  }

  CarouselModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? openingHours,
    String? description,
    List<String>? mainImages,
    List<String>? featureImages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarouselModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      openingHours: openingHours ?? this.openingHours,
      description: description ?? this.description,
      mainImages: mainImages ?? this.mainImages,
      featureImages: featureImages ?? this.featureImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
