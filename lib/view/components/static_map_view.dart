import 'package:flutter/material.dart';

/// 店舗アクセスのための静止画地図を表示するウィジェット。
///
/// ユーザーによるパン（移動）およびズーム（拡大・縮小）操作に対応しています。
class StaticMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;

  const StaticMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 400.0,
  });

  @override
  State<StaticMapView> createState() => _StaticMapViewState();
}

class _StaticMapViewState extends State<StaticMapView> {
  /// 地図の変形（拡大・縮小・移動）を制御するコントローラー
  final TransformationController _controller = TransformationController();

  /// 現在の拡大倍率（1.0〜5.0）
  double _currentScale = 1.0;

  /// ボタン押下による拡大・縮小の更新処理
  void _updateZoom(double step) {
    setState(() {
      _currentScale = (_currentScale + step).clamp(1.0, 5.0);
      _controller.value = Matrix4.identity()..scale(_currentScale);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Stack(
        children: [
          Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            clipBehavior: Clip.antiAlias,
            child: InteractiveViewer(
              transformationController: _controller,
              clipBehavior: Clip.none,
              maxScale: 5.0,
              minScale: 1.0,
              // 手動のピンチ操作と内部スケール値を同期
              onInteractionUpdate: (details) {
                _currentScale = _controller.value.getMaxScaleOnAxis();
              },
              child: Image.asset(
                'assets/map_image.png',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Center(child: Text('地図画像が見つかりません')),
              ),
            ),
          ),
          // ズーム操作用のボタンを右下に配置
          Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                _zoomButton(Icons.add, () => _updateZoom(0.5)),
                _zoomButton(
                  Icons.remove,
                  () => _updateZoom(-0.5),
                  isBottom: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ズーム操作に使用する、枠線を共有した矩形ボタン
  Widget _zoomButton(
    IconData icon,
    VoidCallback onPressed, {
    bool isBottom = false,
  }) {
    final borderSide = BorderSide(color: Colors.grey.shade600, width: 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.zero,
        border:
            isBottom
                ? Border(
                  left: borderSide,
                  right: borderSide,
                  bottom: borderSide,
                )
                : Border.all(color: Colors.grey.shade600, width: 1.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, color: Colors.black87, size: 16),
        ),
      ),
    );
  }
}
