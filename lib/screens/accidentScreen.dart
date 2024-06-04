import 'package:flutter/material.dart';

import '../models/accident.dart';

class AccidentScreen extends StatefulWidget {
  AccidentScreen({
    required this.accident,
    Key? key,
  }) : super(key: key);

  final Accident accident;

  @override
  State<AccidentScreen> createState() => _AccidentScreenState();
}

class _AccidentScreenState extends State<AccidentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accident.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(widget.accident.pageTitle),
              Image.network(widget.accident.photoUrl),
              Text(widget.accident.description),
              for (var step in widget.accident.steps)
                Column(
                  children: [
                    Text(step.title),
                    Text(step.description),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
