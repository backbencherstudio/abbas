import 'package:flutter/material.dart';
class PostImageCard extends StatelessWidget {
  final String imageUrl;
  const PostImageCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset("assets/images/background_img.png", fit: BoxFit.cover),
      ),
    );
  }
}
