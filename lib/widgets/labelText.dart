import 'dart:io';

import 'package:flutter/material.dart';
class LabelText extends StatelessWidget {
  const LabelText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(

        fontSize: 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'lato'
      ),

    );
  }
}
