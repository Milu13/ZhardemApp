// ChatScreen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/models/userModel.dart';
import 'package:zhardem/services/userService.dart';
import 'messageScreen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Users> _users = [];

  @override
  void initState() {
    super.initState();
    // Получить список всех пользователей при инициализации виджета
    _getAllUsers();
  }

  // Метод для получения всех пользователей
  void _getAllUsers() async {
    UserService userService = Provider.of<UserService>(context, listen: false);
    List<Users> users = await userService.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_users[index].name),
            subtitle: Text(_users[index].email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageScreen(
                    receiverUserEmail: _users[index].email,
                    receiverUserID: _users[index].uid,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
