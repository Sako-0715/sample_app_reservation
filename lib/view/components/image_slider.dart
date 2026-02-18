import 'dart:async';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String>? imageUrls;
  final List<String>? assetPaths;
  final double height;
  final double viewportFraction;
  final double borderRadius;
  final double imageMargin;
  final bool showIndicator;
  final Color? indicatorColor;
  final Color? inactiveIndicatorColor;
  final void Function(int index)? onTap;

  const ImageSlider({
    super.key,
    this.imageUrls,
    this.assetPaths,
    this.height = 200,
    this.viewportFraction = 0.85,
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

  static const int _infiniteMultiplier = 1000;

  @override
  void initState() {
    super.initState();
    final int realCount = _realItemCount;
    final int initialPage =
        realCount > 0 ? (realCount * (_infiniteMultiplier ~/ 2)) : 0;

    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: initialPage,
    );
    _currentPage = initialPage;

    // 自動スライド開始
    _startAutoPlay();
  }

  // 自動スライド（5秒周期）を開始するメソッド
  void _startAutoPlay() {
    _stopAutoPlay();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && _realItemCount > 1) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // すべてのタイマーを停止するメソッド
  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _restartTimer?.cancel();
    _autoPlayTimer = null;
    _restartTimer = null;
  }

  // 手動でスライド終了から1秒後に再度自動スライドを開始するメソッド
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
      height: widget.height + (widget.showIndicator ? 24 : 0),
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  // 手動操作が始まったら即座にタイマー停止
                  _stopAutoPlay();
                } else if (notification is ScrollEndNotification) {
                  // 手動操作（スワイプ）が終わったら1秒後に再度自動スライドを開始
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
                  final int actualIndex = index % _realItemCount;
                  return _buildImageItem(actualIndex);
                },
              ),
            ),
          ),
          if (widget.showIndicator && _realItemCount > 1) _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.imageMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
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

  Widget _buildIndicator() {
    final int displayIndex = _currentPage % _realItemCount;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_realItemCount, (index) {
          return Container(
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

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image_outlined, size: 64, color: Colors.grey),
      ),
    );
  }
}
