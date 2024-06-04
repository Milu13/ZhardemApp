import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zhardem/services/chatBuble.dart';
import '../services/chatService.dart';


class MessageScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  MessageScreen({
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(context),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    final chatService = Provider.of<ChatService?>(context);
    if (chatService == null) {
      return Center(
        child: Text('Что-то пошло не так. Попробуйте перезагрузить экран.'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessages(
        widget.receiverUserID,
        FirebaseAuth.instance.currentUser!.uid,
      ),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Ошибка ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Нет сообщений'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final senderEmail = snapshot.data!.docs[index]['senderEmail'];
            final message = snapshot.data!.docs[index]['message'];

            final isSender = senderEmail == FirebaseAuth.instance.currentUser!.email;

            return ChatBubble(
              message: message ?? 'Нет сообщения',
              isSender: isSender,
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController controller = TextEditingController();
    var logger = Logger(
      printer: PrettyPrinter(),
    );

    void post(String text) async {
      try {
        final ap = Provider.of<ChatService>(context, listen: false);

        if (text.isNotEmpty) {
          await ap.sendMessage(widget.receiverUserID, text);
          logger.i(text);
        }
      } catch (e) {
        logger.e(e);
      }
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Введите сообщение',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                post(controller.text);
                controller.text = "";
              });
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
