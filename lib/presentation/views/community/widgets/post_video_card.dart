import 'package:flutter/material.dart';

class PostVideoCard extends StatelessWidget {
  final String thumbUrl;
  const PostVideoCard({super.key, required this.thumbUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(thumbUrl, fit: BoxFit.cover),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.9),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: const Icon(
            Icons.play_arrow_rounded,
            size: 32,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
