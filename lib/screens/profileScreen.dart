import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/firstAidScreen.dart';
import 'package:zhardem/screens/historyScreen.dart';
import 'package:zhardem/screens/loginScreen.dart';
import 'package:zhardem/screens/settingsScreen.dart';
import 'package:zhardem/services/MedicalCardService.dart';
import 'package:zhardem/services/userService.dart';
import '../models/profileListModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileListModel story;
  late ProfileListModel settings;
  late ProfileListModel logout;
  late ProfileListModel firstAid;
  late List<ProfileListModel> list;
  late String name = "username";
  String? image;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    super.initState();
    final ap = Provider.of<UserService>(context, listen: false);
    ap.getUserData().then((_) {
      setState(() {
        name = ap.name.isNotEmpty ? ap.name : "username";
        image = ap.image.isNotEmpty ? ap.image : null;
      });
    });

    story = ProfileListModel(Icon(Icons.book_online), "История");
    settings = ProfileListModel(Icon(Icons.settings), "Настройки");
    logout = ProfileListModel(Icon(Icons.logout, color: Colors.red), "Выйти");
    firstAid = ProfileListModel(Icon(Icons.help), "Первая помощь");

    list = [story, settings, firstAid, logout];
  }

  Future<void> _onRefresh() async {
    try {
      final ap = Provider.of<UserService>(context, listen: false);
      await ap.getUserData();

      setState(() {
        name = ap.name.isNotEmpty ? ap.name : "username";
        image = ap.image.isNotEmpty ? ap.image : null;
      });
    } catch (e) {
      logger.e("Что-то пошло не так! $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double appBarHeight = screenSize.height * 0.3;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: appBarHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      image == null
                          ? CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 50,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(image!),
                              radius: 50,
                            ),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: Colors.grey),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: list[index].icon,
                    title: Text(
                      list[index].text,
                      style: index == 3
                          ? const TextStyle(color: Colors.red)
                          : null,
                    ),
                    onTap: () {
                      if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsScreen()),
                        );
                      } else if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryScreen()),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FirstAidScreen()),
                        );
                      } else if (index == 3) {
                        _showLogoutDialog();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  'assets/logo.png', // Путь к вашему логотипу в папке assets
                  width: 150, // Ширина логотипа в диалоге
                  height: 150, // Высота логотипа в диалоге
                ),
              ),
              Text('Выход из аккаунта'),
            ],
          ),
          content: Text('Вы уверены, что хотите выйти из аккаунта?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрыть диалог без действий
                  },
                  child: Text('Отмена'),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Выйти',
                    style: TextStyle(
                      color: Colors.red, // Цвет текста кнопки выхода
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
