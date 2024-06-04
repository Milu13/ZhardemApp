

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/models/medicalRecordModel.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';
import '../services/MedicalCardService.dart';
import 'editMedicalCardScreen.dart';

class MedicalCardScreen extends StatefulWidget {
  const MedicalCardScreen({Key? key}) : super(key: key);

  @override
  _MedicalCardScreenState createState() => _MedicalCardScreenState();
}

class _MedicalCardScreenState extends State<MedicalCardScreen> {

  var logger = Logger(
    printer: PrettyPrinter(),
  );


  @override
  void initState() {
    super.initState();
    // Вызовите метод getMedicalRecord() при инициализации страницы
    getCards();
  }



  Future<void> getCards() async{
    try{
      final ap = Provider.of<MedicalCardService>(context,listen: false);
      ap.getMedicalRecord();

      logger.i(("метод getCards выполнился!"));
    }
    catch(e){
      logger.e("метод getCards не выполнился! /n $e");
    }
  }

  Future<void> deleteCard() async{
    try{
      final ap = Provider.of<MedicalCardService>(context,listen: false);
      ap.deleteMedicalCardByIIN(ap.iin);

      logger.i("Мед. карта успешно удалена!");
    }
    catch(e){
      logger.e("Что-то пошло не так! $e");
    }
  }

  Future<void> _onRefresh()async {
    try{
      final ap = Provider.of<MedicalCardService>(context,listen: false);
      ap.getMedicalRecord();


    }
    catch(e){
      logger.e(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MedicalCardService>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Медицинская карта'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditMedicalCardScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _onRefresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: getCards,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Личные данные
                ExpansionTile(
                  title: const Text('Личные данные'),
                  children: [

                    Text('Имя: ${ap.fullName ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('ИИН: ${ap.iin ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('Пол: ${ap.gender ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('Национальность: ${ap.nationality ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('Дата рождения: ${ap.birthDate ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('Семейное положение: ${ap.familyStatus ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('Адрес: ${ap.address ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('Гражданство: ${ap.citizenship ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),

                    Text('Экстренные контакты: ${(ap.emergencyContacts) ?? ''}', textAlign: TextAlign.start, style: TextStyle(fontSize: 18),),
                    const Divider(height: 2, color: Colors.grey),


                  ],
                ),
                // История болезней и т.д.
                ExpansionTile(
                  title: const Text('История болезней и лечение'),
                  children: [
                    if (ap.medicalHistory != null &&
                        ap.medicalHistory.isNotEmpty)
                      ...ap.medicalHistory.map((item) => ListTile(
                        title: Text(item),
                      )),
                    const Divider(color: Colors.grey),
                    if (ap.medications != null &&
                        ap.medications.isNotEmpty)
                      ...ap.medications.map((item) => ListTile(
                        title: Text(item),
                      )),
                  ],
                ),

                ExpansionTile(
                  title: const Text('Аллергии'),
                  children: [
                    if (ap.allergies != null &&
                        ap.allergies.isNotEmpty)
                      ...ap.allergies.map((item) => ListTile(
                        title: Text(item),
                      )),
                  ],
                ),

                ExpansionTile(
                  title: const Text('Состояния'),
                  children: [
                    if (ap.conditions != null &&
                        ap.conditions.isNotEmpty)
                      ...ap.conditions.map((item) => ListTile(
                        title: Text(item),
                      )),
                  ],
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SaveElevatedButton(height: 50, text: "Удалить медицинскую карточку", onPressed: deleteCard)
                  ),
                ),




              ],
            ),
          ),
        ),
      ),
    );
  }
}
