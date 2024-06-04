
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/addAccidentScreen.dart';
import 'package:zhardem/screens/addPlacesScreen.dart';
import 'package:zhardem/screens/basicSettings.dart';
import 'package:zhardem/screens/loginScreen.dart';
import 'package:zhardem/screens/medicalCardScreen.dart';
import 'package:zhardem/screens/notificationSettingsScreen.dart';
import 'package:zhardem/screens/profileEditScreen.dart';
import 'package:zhardem/services/userService.dart';

import 'package:zhardem/widgets/defaultAppBar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  var logger = Logger(
    printer: PrettyPrinter(),
  );


  late List<String> all = [];
  late List<String> profile = [];
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    all.addAll(["Основные", "Уведомление"]);

    profile.addAll(["Редактировать профиль", "Медицинская карточка" , "Добавить место в карту","Изменение пароля", "Удалить аккаунт","Добавить первую помошь"]);
  }

  void deleteAccount() async
  {
    try{
      final ap = Provider.of<UserService>(context,listen: false);
      await ap.deleteUser();
      logger.i("пользователь удален");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>  LoginScreen()), (route) => false);
    }
    catch(error){
      logger.e("ошибка при удалении пользователя \n ============ \n $error \n =============");
    }
  }
  void _showDeleteAccountDialog() {
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
              Text('Удаление аккаунта'),
            ],
          ),
          content: Text('Вы уверены, что хотите удалить аккаунт?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрыть диалог без действий
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: deleteAccount,
                  child: const Text(
                    'Удалить',
                    style: TextStyle(
                      color: Colors.red, // Цвет текста кнопки удаления
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

  void _showChangePasswordDialog() {
    String oldPassword = '';
    String newPassword = '';
    String confirmPassword = '';

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
              Text('Изменение пароля'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Старый пароль'),
                obscureText: true,
                onChanged: (value) {
                  oldPassword = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Новый пароль'),
                obscureText: true,
                onChanged: (value) {
                  newPassword = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Подтвердите пароль'),
                obscureText: true,
                onChanged: (value) {
                  confirmPassword = value;
                },
              ),
            ],
          ),
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
                  onPressed: () {
                    if (newPassword == confirmPassword) {
                      // Добавьте логику для изменения пароля
                      print('Старый пароль: $oldPassword');
                      print('Новый пароль: $newPassword');
                      Navigator.of(context).pop(); // Закрыть диалог после изменения пароля
                    } else {
                      // Если новый пароль не совпадает с подтверждением
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Ошибка'),
                            content: Text('Новый пароль не совпадает с подтверждением.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    'Изменить',
                    style: TextStyle(
                      color: Colors.blue, // Цвет текста кнопки изменения
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



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const DefaultAppBar(text: 'Настройки'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Общие", screenHeight),
            ListView.builder(
              shrinkWrap: true,
              itemCount: all.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      all[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      // Add functionality for ListTile onTap if needed
                      if (index == 0) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BasicSettings()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
                      }
                    },
                    trailing: index == 1
                        ? Switch(
                      value: notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
                      },
                    )
                        : const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
            _buildSectionTitle("Профиль", screenHeight),
            ListView.builder(
              shrinkWrap: true,
              itemCount: profile.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      profile[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      // Add functionality for ListTile onTap if needed
                      if (index == 0) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditScreen()));
                      }
                      else if(index == 1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalCardScreen()));
                      }
                      else if(index==2){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddPlacesScreen()));
                      }
                      else if(index ==3){
                        _showChangePasswordDialog();
                      }
                      else if(index ==4 ){
                        _showDeleteAccountDialog();
                      }
                      else if(index == 5){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddAccidentScreen()));
                      }
                    },
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenHeight * 0.04,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
