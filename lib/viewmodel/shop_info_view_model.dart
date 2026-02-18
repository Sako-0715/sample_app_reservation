import 'package:flutter/material.dart';
import '../model/carousel_model.dart';
import '../model/pickup_model.dart';
import '../service/shop_info_api.dart';

class ShopInfoViewModel extends ChangeNotifier {
  final ShopInfoApi _api = ShopInfoApi();

  // 状態を保持する変数
  CarouselModel? _shop;
  List<PickupModel> _pickups = []; // 新たに追加：ピックアップリストの変数
  bool _isLoading = false;
  String? _errorMessage;

  // 外部（UI）から参照するためのゲッター
  CarouselModel? get shop => _shop;
  List<PickupModel> get pickups => _pickups; // 新たに追加：ピックアップのゲッター
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 店舗情報を取得して状態を更新する
  Future<void> loadShopInfo() async {
    _isLoading = true;
    _errorMessage = null;
    // 画面に「読み込み開始」を通知
    notifyListeners();

    try {
      // 修正：スライダー情報とピックアップ情報を並列で取得（Future.waitで効率化）
      final results = await Future.wait([
        _api.fetchShopInfo(),
        _api.fetchPickups(), // API側で追加したピックアップ取得メソッドを呼ぶ
      ]);

      _shop = CarouselModel.fromJson(results[0] as Map<String, dynamic>);

      // 新たに追加：ピックアップデータのパース処理
      // ✅ JSONが「リスト形式」か「単体オブジェクト形式」かを判定して処理
      final dynamic rawData = results[1];

      if (rawData is List) {
        // [A, B, C] の形式で来ている場合
        _pickups = rawData.map((json) => PickupModel.fromJson(json)).toList();
      } else if (rawData is Map<String, dynamic>) {
        if (rawData.containsKey('contents')) {
          // microCMSのリスト形式 { "contents": [...] } の場合
          final List<dynamic> list = rawData['contents'] as List<dynamic>;
          _pickups = list.map((json) => PickupModel.fromJson(json)).toList();
        } else {
          // ✅ 今回のケース：単体オブジェクト { "title": "..." } の場合、リストに包む
          _pickups = [PickupModel.fromJson(rawData)];
        }
      } else {
        // データが取れなかった場合
        _pickups = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
      print("ViewModel Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
