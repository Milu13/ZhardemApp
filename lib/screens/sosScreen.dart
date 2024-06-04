import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zhardem/screens/firstAidScreen.dart';
import 'package:zhardem/services/MedicalCardService.dart';
import 'package:zhardem/widgets/labelText.dart';
import '../models/Contacts.dart';
import '../widgets/imageButton.dart';

class SosScreen extends StatefulWidget {
  SosScreen({Key? key}) : super(key: key);

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  List<Contacts> contacts = [];

  final List<String> imageUrls = const [
    'assets/police.png',
    'assets/nurse.png',
    'assets/firefighter.png',
    // Добавьте другие пути к изображениям здесь
  ];

  final Contacts police = Contacts(contactName: "Полиция", phoneNumber: "102", emailAddress: "");
  final Contacts med = Contacts(contactName: "Больница", phoneNumber: "103", emailAddress: "");
  final Contacts fire = Contacts(contactName: "Пожарный", phoneNumber: "102", emailAddress: "");

  void getContacts() async {
    try {
      final ap = Provider.of<MedicalCardService>(context, listen: false);
      List<Contacts> tempContacts = await ap.getContacts();
      setState(() {
        contacts.clear();
        contacts.add(police);
        contacts.add(med);
        contacts.add(fire);
        contacts.addAll(tempContacts);
      });
      logger.i("${ap.emergencyContacts}");
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  void makePhoneCall(String phoneNumber) async {
    try {
      String url = 'tel:$phoneNumber';
      if (await canLaunch(url)) {
        await launch(url);
        logger.i("звонок по номеру телефона $phoneNumber");
      } else {
        logger.e("Не удалось совершить звонок на номер $phoneNumber");
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    try {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text('экстренные номера', textAlign: TextAlign.center,),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(contacts[index].contactName),
                    subtitle: Text(contacts[index].phoneNumber),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            // Действие при нажатии на кнопку сообщения
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () {
                            // Действие при нажатии на кнопку звонка
                            makePhoneCall(contacts[index].phoneNumber);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Действие при нажатии на список контактов
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    } catch (E) {
      // Обработка ошибок, если необходимо
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LabelText(text: "Нужна экстренная помощь?"),
                const Text(
                  "Нажмите кнопку для вызова",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FirstAidScreen()));
                  },
                  child: Text(
                    'Первая помощь',
                    style: TextStyle(color: Colors.red, fontSize: screenHeight * 0.02),
                  ),
                ),
                ImageButton(
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                  image: const AssetImage("assets/sos.png"),
                  width: screenWidth * 0.8, // Настройте ширину по вашему желанию
                  height: screenHeight * 0.4, // Настройте высоту по вашему желанию
                ),
                CarouselSlider.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (BuildContext context, int index, int realIndex) {
                    return ImageButton(
                      onPressed: () {
                        // Действие при нажатии на изображение (необязательно)
                        if(index == 0){
                          makePhoneCall('+77478601443');
                        }
                        else if(index==1){
                          makePhoneCall('+77478601443');
                        }
                        else{
                          makePhoneCall('+77478601443');
                        }
                        print('Image $index pressed');
                      },
                      image: AssetImage(imageUrls[index]),
                      width: screenWidth * 0.3, 
                      height: screenHeight * 0.1, 
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.2, // Настройте высоту по вашему желанию
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: screenWidth / (screenHeight * 0.2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                    viewportFraction: 0.8,
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
