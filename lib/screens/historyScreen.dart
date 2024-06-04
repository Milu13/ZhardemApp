import 'package:flutter/material.dart';
import 'package:zhardem/widgets/defaultAppBar.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(text: "История"),
    );

  }
}
