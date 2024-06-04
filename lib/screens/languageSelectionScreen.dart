import 'package:flutter/material.dart';
import 'package:zhardem/widgets/defaultAppBar.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = ''; // Переменная для хранения выбранного языка

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(text: "Выбор языка"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RadioListTile<String>(
              title: Text('Қазақ тілі'),
              value: 'kazakh',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
              activeColor: Colors.green, // Цвет галочки при выборе
            ),
            RadioListTile<String>(
              title: Text('Русский'),
              value: 'russian',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
              activeColor: Colors.green, // Цвет галочки при выборе
            ),
            RadioListTile<String>(
              title: Text('Английский'),
              value: 'english',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
              activeColor: Colors.green, // Цвет галочки при выборе
            ),
            const SizedBox(height: 20),
            SaveElevatedButton(height: 50, text: "Применить", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
