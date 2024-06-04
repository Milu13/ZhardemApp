import 'package:flutter/material.dart';
class ImageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ImageProvider image;
  final double width;
  final double height;

  ImageButton({
    required this.onPressed,
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: width,
        height: height,
        child: Image(
          image: image,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}