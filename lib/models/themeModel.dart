import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = ThemeData.light(); // Используем светлую тему по умолчанию

  void toggleTheme() {
    currentTheme = currentTheme == ThemeData.dark() ? ThemeData.light() : ThemeData.dark();
    notifyListeners();
  }
}
