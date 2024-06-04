import 'package:zhardem/models/step.dart';

class Accident {
  String title;
  String pageTitle;
  String photoUrl;
  String description;
  List<Steps> steps;

  Accident({
    required this.title,
    required this.pageTitle,
    required this.photoUrl,
    required this.description,
    required this.steps,
  });
}