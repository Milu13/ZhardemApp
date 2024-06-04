import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/languageSelectionScreen.dart';
import 'package:zhardem/widgets/defaultAppBar.dart';

import '../models/themeModel.dart';
class BasicSettings extends StatefulWidget {
  const BasicSettings({super.key});

  @override
  State<BasicSettings> createState() => _BasicSettingsState();
}

class _BasicSettingsState extends State<BasicSettings> {
  bool switchValue = false; // Пример значения для переключателя
  void switchValueChanged(bool newValue) {
    // Обработка изменения значения переключателя
    setState(() {
      switchValue = newValue;
      // Дополнительная логика при изменении значения переключателя
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: const DefaultAppBar(text: "Основные"),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(

              child: ListTile(
                title: Text("язык интерфейса"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.
                    push(context,
                                MaterialPageRoute(builder: (context) =>  LanguageSelectionScreen())
                  );
                }
              ),

            ),
            Card(

              child: ListTile(
                title: Text("темный фон"),
                trailing: Switch(
                  value: Provider.of<ThemeModel>(context).currentTheme == ThemeData.dark(),
                  onChanged: (value) {
                    Provider.of<ThemeModel>(context, listen: false).toggleTheme();
                  },
                ),
              ),

            ),
          ],
        ),
      )


    );
  }
}
