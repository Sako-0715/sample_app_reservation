import 'package:flutter/material.dart';
import '../model/carousel_model.dart';
import '../model/pickup_model.dart';
import '../service/shop_info_api.dart';

/// 店舗の基本情報およびピックアップ情報を管理し、UIに通知するViewModel。
class ShopInfoViewModel extends ChangeNotifier {
  /// API通信を担当するサービスインスタンス
  final ShopInfoApi _api = ShopInfoApi();

  /// 取得した店舗情報のデータモデル
  CarouselModel? _shop;

  /// 取得したピックアップ情報のリスト
  List<PickupModel> _pickups = [];

  /// 通信中かどうかを示すフラグ
  bool _isLoading = false;

  /// エラー発生時のメッセージ
  String? _errorMessage;

  CarouselModel? get shop => _shop;
  List<PickupModel> get pickups => _pickups;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 店舗情報とピックアップ情報を非同期で取得し、状態を更新します。
  Future<void> loadShopInfo() async {
    _isLoading = true;
    _errorMessage = null;
    // 読み込み開始状態をUIに通知
    notifyListeners();

    try {
      // 複数のAPIリクエストを並列で実行
      final results = await Future.wait([
        _api.fetchShopInfo(),
        _api.fetchPickups(),
      ]);

      _shop = CarouselModel.fromJson(results[0] as Map<String, dynamic>);

      final dynamic rawData = results[1];

      // APIからのレスポンス形式（Map内のリスト、直接のリスト、単一Map）に応じてパース処理を分岐
      if (rawData is Map<String, dynamic> && rawData.containsKey('contents')) {
        final List<dynamic> list = rawData['contents'] as List<dynamic>;
        _pickups =
            list
                .map(
                  (json) => PickupModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
      } else if (rawData is List) {
        _pickups =
            rawData
                .map(
                  (json) => PickupModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
      } else if (rawData is Map<String, dynamic>) {
        _pickups = [PickupModel.fromJson(rawData)];
      } else {
        _pickups = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
      print("ViewModel Error: $e");
    } finally {
      _isLoading = false;
      // 最終的な状態（成功または失敗）をUIに通知
      notifyListeners();
    }
  }
}
