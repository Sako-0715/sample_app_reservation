# GitHub Copilot 開発指示書

このドキュメントは、`sample_app_reservation`プロジェクトにおけるコーディング規約と開発ガイドラインを定義します。

## 📋 プロジェクト概要

- **プロジェクト名**: sample_app_reservation
- **説明**: Flutter製予約管理アプリケーション
- **対応プラットフォーム**: Android, iOS, Web, Windows, Linux, macOS
- **Flutter SDK**: 3.7.2以上

---

## 🗂️ フォルダ構成ルール

### 基本構造

```
lib/
├── main.dart                      # アプリケーションエントリーポイント
├── view/                          # UI層（画面とコンポーネント）
│   ├── home/                      # ホーム画面関連
│   │   ├── home_screen.dart       # ホーム画面のメイン
│   │   └── shop_info_view.dart    # 店舗情報ビュー
│   ├── components/                # 再利用可能なUIコンポーネント
│   │   ├── custom_tab_bar.dart    # カスタムタブバー
│   │   ├── image_slider.dart      # 画像スライダー
│   │   └── card.dart              # カード型コンポーネント
│   └── [feature]/                 # 各機能ごとのフォルダ
│       ├── [feature]_screen.dart  # メイン画面
│       └── widgets/               # その機能専用のWidget
├── model/                         # データモデル（今後追加予定）
│   └── [entity]_model.dart
├── viewmodel/                     # ビジネスロジック・状態管理
│   └── [feature]_notifier.dart
├── repository/                    # データ取得・永続化層
│   └── [feature]_repository.dart
├── service/                       # 外部API通信・ビジネスロジック
│   └── [feature]_service.dart
└── util/                          # ユーティリティ・定数
    ├── constants.dart
    └── helpers.dart
```

### フォルダ配置の原則

1. **view/components/**
   - アプリ全体で再利用可能なUIコンポーネント
   - 例: `CustomTabBar`, `ImageSlider`, `CustomButton`

2. **view/[feature]/**
   - 特定機能の画面を配置
   - その機能専用のウィジェットは `widgets/` サブフォルダに配置

3. **model/**
   - データクラス・エンティティを配置
   - immutableなデータ構造を推奨

4. **viewmodel/**
   - 状態管理ロジック（ChangeNotifier等）
   - UIとビジネスロジックの橋渡し

5. **repository/**
   - データの取得・保存処理
   - API通信やローカルDB操作

---

## 🎯 状態管理ルール

### 現在の実装状況

- **基本**: `StatelessWidget` / `StatefulWidget`
- **タブ管理**: `DefaultTabController`
- **シンプルな画面状態**: `setState()`

### 今後の状態管理方針

複雑な状態管理が必要になった場合は、以下のパターンを採用します：

#### ✅ 推奨: Provider / Riverpod パターン

```dart
// viewmodel/reservation_notifier.dart
import 'package:flutter/material.dart';

class ReservationNotifier extends ChangeNotifier {
  List<Reservation> _reservations = [];
  bool _isLoading = false;

  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;

  Future<void> fetchReservations() async {
    _isLoading = true;
    notifyListeners();

    // データ取得処理
    _reservations = await _repository.getReservations();

    _isLoading = false;
    notifyListeners();
  }

  void addReservation(Reservation reservation) {
    _reservations.add(reservation);
    notifyListeners();
  }
}
```

#### 使用例

```dart
// main.dartでProviderを設定
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ReservationNotifier()),
  ],
  child: MyApp(),
);

// 画面で使用
class ReservationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ReservationNotifier>(context);

    return ListView.builder(
      itemCount: notifier.reservations.length,
      itemBuilder: (context, index) {
        final reservation = notifier.reservations[index];
        return ListTile(title: Text(reservation.name));
      },
    );
  }
}
```

### 状態管理の使い分け

| 状態の種類                           | 推奨手法                                  | 備考                   |
| ------------------------------------ | ----------------------------------------- | ---------------------- |
| ローカルUI状態（チェックボックス等） | `setState()`                              | 他の画面に影響しない   |
| 画面間共有状態                       | `Provider`                                | ログイン状態、カート等 |
| 非同期データ取得                     | `ChangeNotifier` + `Provider`             | API通信結果の管理      |
| タブ・ページ切り替え                 | `DefaultTabController` / `PageController` | 標準ウィジェット利用   |

---

## 🧩 Widgetの分割指針

### 原則

1. **単一責任の原則（SRP）**
   - 1つのWidgetは1つの明確な役割を持つ
   - 責任が複数ある場合は分割を検討

2. **再利用性**
   - 2回以上使われる可能性があるUI要素は独立したWidgetに
   - コピペが発生したら即座に共通化

3. **可読性**
   - `build()`メソッドが100行を超えたら分割を検討
   - ネストが深すぎる（4階層以上）場合は抽出

### ❌ 悪い例: すべてを1つのWidgetに詰め込む

```dart
class ShopInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 200行以上のコードが続く...
          Container(...),
          Padding(...),
          Row(...),
          // ...
        ],
      ),
    );
  }
}
```

### ✅ 良い例: 責任ごとに分割

```dart
class ShopInfoView extends StatelessWidget {
  const ShopInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ImageSlider(),        // スライダーコンポーネント
          const ShopFeatures(),       // 特徴セクション
          const ShopBasicInfo(),      // 基本情報セクション
          const ShopMap(),            // 地図セクション
        ],
      ),
    );
  }
}

class ShopFeatures extends StatelessWidget {
  const ShopFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('当店の特徴PickUp', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 16),
          const ImageSlider(),
          const SizedBox(height: 12),
          const Text('厳選された旬の食材を...'),
        ],
      ),
    );
  }
}
```

### プライベートメソッド vs 独立Widget

```dart
// ✅ シンプルなUI要素 → プライベートメソッド
class ShopInfoView extends StatelessWidget {
  Widget _buildDetailRow(IconData icon, String label, String content) {
    return Row(
      children: [
        Icon(icon),
        Text('$label: '),
        Text(content),
      ],
    );
  }
}

// ✅ 複雑・再利用可能 → 独立したWidget
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String content;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}
```

---

## 📝 Dart命名規則の徹底

### クラス名: UpperCamelCase（PascalCase）

```dart
// ✅ 正しい
class ShopInfoView extends StatelessWidget {}
class ReservationNotifier extends ChangeNotifier {}
class CustomTabBar extends StatelessWidget {}
class ImageSlider extends StatelessWidget {}

// ❌ 間違い
class shopInfoView extends StatelessWidget {}
class reservation_notifier extends ChangeNotifier {}
class customtabbar extends StatelessWidget {}
```

### 変数・関数名: lowerCamelCase

```dart
// ✅ 正しい
String shopName = 'サンプルカフェ';
int reservationCount = 0;
void addReservation() {}
Future<void> fetchShopInfo() async {}
final List<String> imageUrls = [];

// ❌ 間違い
String ShopName = 'サンプルカフェ';
int reservation_count = 0;
void AddReservation() {}
final List<String> image_urls = [];
```

### ファイル名: snake_case

```dart
// ✅ 正しい
shop_info_view.dart
custom_tab_bar.dart
image_slider.dart
reservation_notifier.dart
shop_repository.dart

// ❌ 間違い
ShopInfoView.dart
customTabBar.dart
ImageSlider.dart
ReservationNotifier.dart
```

### 定数: lowerCamelCase または kPrefix

```dart
// ✅ 正しい（どちらでも可）
const double defaultHeight = 200.0;
const int maxReservations = 10;

// Flutter風のk接頭辞スタイルも可
const double kDefaultHeight = 200.0;
const Color kPrimaryColor = Colors.orange;
const String kApiBaseUrl = 'https://api.example.com';

// ❌ 間違い
const double DEFAULT_HEIGHT = 200.0;
const int Max_Reservations = 10;
```

### プライベート識別子: アンダースコア接頭辞

```dart
// ✅ 正しい
class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;
  String _userName = '';

  void _incrementCounter() {
    setState(() => _counter++);
  }

  Widget _buildHeader() {
    return Text('Header');
  }
}

// ✅ ファイル内でのみ使用するトップレベル変数・関数
const String _apiKey = 'secret_key';
void _logDebug(String message) {
  print('[DEBUG] $message');
}
```

### Enumとtypedef

```dart
// ✅ Enum: UpperCamelCase
enum ReservationStatus {
  pending,
  confirmed,
  cancelled,
}

// ✅ typedef: UpperCamelCase
typedef ReservationCallback = void Function(Reservation);
typedef JsonMap = Map<String, dynamic>;
```

---

## 🎨 コーディングスタイル

### constの積極的な使用

```dart
// ✅ 正しい: パフォーマンス向上のためconstを使用
class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      tabs: [
        Tab(icon: Icon(Icons.info)),
        Tab(icon: Icon(Icons.confirmation_number)),
      ],
    );
  }
}

// ✅ constコンストラクタを優先
const SizedBox(height: 16)
const EdgeInsets.all(16.0)
const Text('店舗情報')
```

### パディング・マージンは8の倍数

```dart
// ✅ 正しい: 8, 16, 24, 32...
const EdgeInsets.all(16.0)
const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
const SizedBox(height: 24)
const EdgeInsets.only(top: 32, left: 16)

// ❌ 間違い: 中途半端な数値
const EdgeInsets.all(13.0)
const SizedBox(height: 23)
const EdgeInsets.symmetric(horizontal: 15, vertical: 7)
```

### インポート順序

```dart
// 1. Dart標準ライブラリ
import 'dart:async';
import 'dart:convert';

// 2. Flutterライブラリ
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. サードパーティパッケージ（アルファベット順）
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// 4. プロジェクト内のファイル（相対パスではなくpackageパス）
import 'package:sample_app_reservation/model/reservation_model.dart';
import 'package:sample_app_reservation/view/components/custom_tab_bar.dart';
import 'package:sample_app_reservation/viewmodel/reservation_notifier.dart';
```

### 改行とインデント

```dart
// ✅ 長い引数リストは改行して読みやすく
Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(50),
  ),
  child: const Text('コンテンツ'),
)

// ✅ メソッドチェーンも適宜改行
final filteredItems = reservations
    .where((r) => r.status == ReservationStatus.confirmed)
    .map((r) => r.shopName)
    .toList();
```

---

## 🎨 UI/UXガイドライン

### カラーパレット

このプロジェクトで使用している主要な色：

```dart
// プライマリカラー
Colors.orange[700]      // 選択状態・アクセントカラー
Colors.blueAccent       // アイコン・リンク

// 背景色
Colors.grey[200]        // タブバー背景
Colors.white            // 基本背景

// テキストカラー
Colors.black87          // 本文テキスト
Colors.white            // 選択中のテキスト
Colors.grey[600]        // 未選択のテキスト・補足情報
```

### レイアウト指針

```dart
// ✅ スクロール可能なコンテンツ
SingleChildScrollView(
  child: Column(children: [...]),
)

// ✅ タブベースのナビゲーション
DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppBar(bottom: TabBar(...)),
    body: TabBarView(children: [...]),
  ),
)

// ✅ カード型UI
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(...)],
  ),
)

// ✅ 画像スライダー
PageView.builder(
  controller: PageController(viewportFraction: 0.85),
  itemBuilder: (context, index) => ...,
)
```

### アクセシビリティ

- **タップ領域**: 最小48x48dp（Materialガイドライン準拠）
- **コントラスト比**: テキストと背景のコントラスト比4.5:1以上
- **アイコンラベル**: すべてのアイコンに意味を持つテキストラベルを併記

---

## 💬 コメント規約

### 日本語コメントを推奨

このプロジェクトでは**日本語コメント**を推奨します。

```dart
// ✅ 正しい: 日本語でわかりやすく
/// 店舗情報を表示するメインビュー
class ShopInfoView extends StatelessWidget {
  const ShopInfoView({super.key});

  /// 詳細情報の行を構築する
  ///
  /// [icon] 表示するアイコン
  /// [label] ラベルテキスト
  /// [content] 表示する内容
  Widget buildDetailRow(IconData icon, String label, String content) {
    // アイコンと文字を横並びで表示
    return Row(...);
  }
}

// ✅ 複雑なロジックには説明を追加
/// ユーザーの予約履歴から直近3件を取得し、
/// 日付の降順でソートして返す
List<Reservation> getRecentReservations(List<Reservation> all) {
  return all
      .where((r) => r.status == ReservationStatus.confirmed)
      .toList()
      ..sort((a, b) => b.date.compareTo(a.date))
      ..take(3);
}
```

### TODOコメント

```dart
// TODO: クーポン一覧画面の実装
// FIXME: 画像読み込み失敗時のエラーハンドリング改善
// NOTE: この処理は将来的にAPIから取得する予定
```

---

## 🧪 テスト指針

### ウィジェットテスト

```dart
// test/widget/custom_tab_bar_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app_reservation/view/components/custom_tab_bar.dart';

void main() {
  testWidgets('CustomTabBarが正しく表示される', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(bottom: CustomTabBar()),
          ),
        ),
      ),
    );

    // タブが2つ表示されることを確認
    expect(find.text('店舗情報'), findsOneWidget);
    expect(find.text('クーポン・メニュー'), findsOneWidget);
  });

  testWidgets('タブの切り替えが正しく動作する', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // 初期状態の確認
    expect(find.text('店舗情報'), findsOneWidget);

    // クーポンタブをタップ
    await tester.tap(find.text('クーポン・メニュー'));
    await tester.pumpAndSettle();

    // 画面遷移の確認
    expect(find.text('お得なクーポン'), findsOneWidget);
  });
}
```

### テストの優先度

1. **高優先**: ユーザー操作に関わる画面・機能
2. **中優先**: データ変換・ビジネスロジック
3. **低優先**: 見た目だけのコンポーネント

---

## 📦 依存関係管理

### pubspec.yaml のルール

```yaml
dependencies:
  flutter:
    sdk: flutter

  # UI関連
  cupertino_icons: ^1.0.8

  # 状態管理（今後追加予定）
  # provider: ^6.0.0

  # ローカルストレージ
  path_provider: ^2.1.5
  # shared_preferences: ^2.0.0  # 今後必要に応じて追加

  # ネットワーク（今後追加予定）
  # http: ^1.0.0
  # dio: ^5.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

### パッケージ追加のルール

1. 必要性を十分に検討（標準機能で実現できないか？）
2. メンテナンス状況を確認（pub.dev のLikes・Popularity・Pub Points）
3. `pubspec.yaml`にコメントで用途を明記

---

## 🔄 Git コミットメッセージ

### フォーマット

```
[種類] 変更内容の概要（50文字以内）

詳細な説明（必要に応じて）
- 変更の理由
- 影響範囲
```

### 種類（Prefix）

| Prefix     | 意味             | 例                                             |
| ---------- | ---------------- | ---------------------------------------------- |
| `feat`     | 新機能追加       | `feat: クーポン一覧画面を追加`                 |
| `fix`      | バグ修正         | `fix: 画像スライダーのスクロール不具合を修正`  |
| `ui`       | UI/UX改善        | `ui: タブバーのデザインをブラッシュアップ`     |
| `refactor` | リファクタリング | `refactor: ShopInfoViewをコンポーネントに分割` |
| `docs`     | ドキュメント更新 | `docs: READMEに環境構築手順を追加`             |
| `test`     | テスト追加・修正 | `test: CustomTabBarのウィジェットテストを追加` |
| `chore`    | ビルド・設定変更 | `chore: pubspec.yamlにproviderを追加`          |

### 良いコミット例

```
feat: 横スライド可能な画像付きカードコンポーネントを実装

- HorizontalCardListウィジェットを追加
- ImageCardウィジェットを追加
- ネットワーク画像とアセット画像の両方に対応
- タップイベントのコールバック機能を実装
```

---

## 🚀 その他のベストプラクティス

### エラーハンドリング

```dart
// ✅ 正しい: try-catchで適切にエラー処理
Future<void> fetchShopInfo() async {
  try {
    final response = await http.get(Uri.parse('...'));
    if (response.statusCode == 200) {
      // 正常処理
    } else {
      throw Exception('Failed to load shop info');
    }
  } catch (e) {
    print('Error: $e');
    // ユーザーにエラーメッセージを表示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('データの取得に失敗しました')),
    );
  }
}
```

### Null Safety

```dart
// ✅ 正しい: nullable型を明示的に扱う
String? userName;  // nullableな文字列

// null チェック
if (userName != null) {
  print(userName.length);  // 安全にアクセス
}

// ?? 演算子でデフォルト値
final displayName = userName ?? 'ゲスト';

// ?. 演算子でnull-safe呼び出し
final length = userName?.length;
```

### 非同期処理

```dart
// ✅ async/await を使った読みやすいコード
Future<void> loadData() async {
  final shopInfo = await fetchShopInfo();
  final reservations = await fetchReservations(shopInfo.id);
  setState(() {
    _shopInfo = shopInfo;
    _reservations = reservations;
  });
}

// ✅ FutureBuilderの活用
FutureBuilder<ShopInfo>(
  future: fetchShopInfo(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('エラー: ${snapshot.error}');
    }
    final shopInfo = snapshot.data!;
    return Text(shopInfo.name);
  },
)
```

---

## 📚 参考リソース

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://flutter.dev/docs/development/ui/widgets)
- [Material Design Guidelines](https://material.io/design)
- [Flutter公式ドキュメント（日本語）](https://docs.flutter.dev/get-started/install)

---

**最終更新**: 2026年2月17日  
**バージョン**: 1.0.0

この指示書は、プロジェクトの成長に合わせて継続的に更新してください。
