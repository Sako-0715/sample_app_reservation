import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    // 表示したい画像のリスト
    final List<String> images = [
      'https://via.placeholder.com/600x400/FF5733/FFFFFF',
      'https://via.placeholder.com/600x400/33FF57/FFFFFF',
      'https://via.placeholder.com/600x400/3357FF/FFFFFF',
    ];

    return SizedBox(
      height: 200, // スライダーの高さ
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85), // 前後の画像を少し見せる
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
