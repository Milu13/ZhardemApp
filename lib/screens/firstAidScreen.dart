import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/models/accident.dart';
import 'package:zhardem/screens/accidentScreen.dart';
import 'package:zhardem/services/accidentService.dart';
import '../widgets/searchAppBar.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({Key? key}) : super(key: key);

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  List<Accident> accidents = [];

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    super.initState();
    fetchAccidents();
  }

  Future<void> fetchAccidents() async {
    try {
      final ap = Provider.of<AccidentService>(context, listen: false);
      List<Accident> fetchedAccidents = await ap.getAllAccidents();
      setState(() {
        accidents = fetchedAccidents;
      });
      logger.i("Данные успешно загружены");

      for (var accident in accidents) {
        logger.i("========");
        logger.i(accident.title);
        logger.i(accident.description);
      }
    } catch (e) {
      logger.e("Ошибка загрузки данных: $e");
    }
  }

  Future<void> deleteAccident(int index) async {
    try {
      if (index >= 0 && index < accidents.length) {
        final ap = Provider.of<AccidentService>(context, listen: false);
        await ap.deleteAccident(accidents[index]);
        setState(() {
          accidents.removeAt(index);
        });
        logger.i("Авария успешно удалена");
      } else {
        logger.e("Ошибка: Недопустимый индекс");
      }
    } catch (e) {
      logger.e("Ошибка удаления: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Первая помощь!'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchAccidents,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: accidents.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(accidents[index].title),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Подтверждение"),
                        content: Text("Вы уверены, что хотите удалить этот элемент?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Отмена"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Удалить"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  setState(() {
                    deleteAccident(index);
                  });
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  child: ListTile(
                    title: Text(accidents[index].title, textAlign: TextAlign.center),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AccidentScreen(accident: accidents[index])),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
