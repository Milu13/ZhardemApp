import 'package:flutter/material.dart';
class RedTextButton extends StatelessWidget {
  const RedTextButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
