// service/shop_info_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShopInfoApi {
  static const String baseUrl = 'https://reservation-app.microcms.io/api/v1';
  static const String apiKey = 'Uigt0k57lNK9sV8n8zMiglFJ2j0hEOM9kI5T';

  /// 店舗情報を取得
  Future<Map<String, dynamic>> fetchShopInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/image'),
      headers: {'X-MICROCMS-API-KEY': apiKey},
    );

    if (response.statusCode == 200) {
      // JSON文字列 → Map<String, dynamic> に変換するだけ
      return json.decode(response.body);
    } else {
      throw Exception('API通信失敗');
    }
  }

  /// ピックアップ情報を取得（新設）
  /// ピックアップ情報を取得
  Future<dynamic> fetchPickups() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pickup'),
      headers: {'X-MICROCMS-API-KEY': apiKey},
    );

    if (response.statusCode == 200) {
      // JSONをデコードしてそのまま返す（MapかListかはViewModelで判断する）
      return json.decode(response.body);
    } else {
      throw Exception('ピックアップ通信失敗');
    }
  }
}
