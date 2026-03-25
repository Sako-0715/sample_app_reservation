import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// 3Dカルーセル効果を持つ無限スクロール画像スライダー。
///
/// ネットワーク画像またはアセット画像を表示し、中心からの距離に応じて
/// 回転・縮小・透過を行うことで円状に動いているような視覚効果を提供します。
class ImageSlider extends StatefulWidget {
  /// 表示するネットワーク画像のURLリスト
  final List<String>? imageUrls;

  /// 表示するアセット画像のパスリスト
  final List<String>? assetPaths;

  /// スライダーの高さ
  final double height;

  /// 各ページの表示占有率（0.0 〜 1.0）
  final double viewportFraction;

  /// 画像の角丸
  final double borderRadius;

  /// 画像間の余白
  final double imageMargin;

  /// インジケーターを表示するかどうか
  final bool showIndicator;

  /// 選択中のインジケーターの色
  final Color? indicatorColor;

  /// 非選択時のインジケーターの色
  final Color? inactiveIndicatorColor;

  /// 画像タップ時のコールバック
  final void Function(int index)? onTap;

  const ImageSlider({
    super.key,
    this.imageUrls,
    this.assetPaths,
    this.height = 200,
    this.viewportFraction = 0.7,
    this.borderRadius = 16,
    this.imageMargin = 8,
    this.showIndicator = true,
    this.indicatorColor,
    this.inactiveIndicatorColor,
    this.onTap,
  }) : assert(imageUrls != null || assetPaths != null);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  Timer? _restartTimer;

  /// 無限スクロールを実現するための倍率
  static const int _infiniteMultiplier = 1000;

  @override
  void initState() {
    super.initState();
    final int realCount = _realItemCount;
    // 無限スクロールの中央付近から開始するように初期ページを設定
    final int initialPage =
        realCount > 0 ? (realCount * (_infiniteMultiplier ~/ 2)) : 0;

    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: initialPage,
    );
    _currentPage = initialPage;
    _startAutoPlay();
  }

  /// 自動スライドを開始する
  void _startAutoPlay() {
    _stopAutoPlay();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && _realItemCount > 1) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  /// すべてのタイマーを停止する
  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _restartTimer?.cancel();
  }

  /// スクロール終了後に自動スライドを再開する
  void _handleScrollEnd() {
    _restartTimer?.cancel();
    _restartTimer = Timer(const Duration(seconds: 1), () {
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  int get _realItemCount =>
      widget.imageUrls?.length ?? widget.assetPaths?.length ?? 0;

  @override
  Widget build(BuildContext context) {
    if (_realItemCount == 0) {
      return SizedBox(height: widget.height, child: _buildPlaceholder());
    }

    return SizedBox(
      height: widget.height + (widget.showIndicator ? 32 : 0),
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  _stopAutoPlay();
                } else if (notification is ScrollEndNotification) {
                  _handleScrollEnd();
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount:
                    _realItemCount > 1
                        ? _realItemCount * _infiniteMultiplier
                        : 1,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      // 現在のスクロール位置と各要素の距離を計算（0.0が中心）
                      double value = 0.0;
                      if (_pageController.position.haveDimensions) {
                        value = index.toDouble() - (_pageController.page ?? 0);
                      } else {
                        value = (index - _currentPage).toDouble();
                      }

                      // 円状の動きを演出するためのパラメータ計算
                      double scale = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
                      double rotationY = (value * 0.4).clamp(-1.0, 1.0);
                      double opacity = (1 - (value.abs() * 0.4)).clamp(
                        0.0,
                        1.0,
                      );

                      return Transform(
                        alignment: Alignment.center,
                        transform:
                            Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // 遠近感（パース）の適用
                              ..rotateY(rotationY) // Y軸の回転
                              ..scale(scale), // 拡大縮小
                        child: Opacity(
                          opacity: opacity,
                          child: _buildImageItem(index % _realItemCount),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          if (widget.showIndicator && _realItemCount > 1) _buildIndicator(),
        ],
      ),
    );
  }

  /// 個別の画像アイテムを構築する
  Widget _buildImageItem(int index) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(index),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: widget.imageMargin,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: _buildImage(index),
        ),
      ),
    );
  }

  /// 指定されたインデックスの画像を構築する
  Widget _buildImage(int index) {
    if (widget.imageUrls != null) {
      return Image.network(
        widget.imageUrls![index],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    } else if (widget.assetPaths != null) {
      return Image.asset(
        widget.assetPaths![index],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  /// ページ位置を示すインジケーターを構築する
  Widget _buildIndicator() {
    final int displayIndex = _currentPage % _realItemCount;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_realItemCount, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color:
                  displayIndex == index
                      ? (widget.indicatorColor ?? Colors.black)
                      : (widget.inactiveIndicatorColor ?? Colors.grey[400]),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  /// 画像がない場合のプレースホルダー
  Widget _buildPlaceholder() => Container(
    color: Colors.grey[300],
    child: const Center(
      child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
    ),
  );

  /// 画像読み込み失敗時のプレースホルダー
  Widget _buildErrorPlaceholder() => Container(
    color: Colors.grey[300],
    child: const Center(
      child: Icon(Icons.broken_image_outlined, size: 64, color: Colors.grey),
    ),
  );
}
