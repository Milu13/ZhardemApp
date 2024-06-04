import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  late String senderID;
  late String senderEmail;
  late String receiverID;
  late String message;
  late Timestamp timestamp;

  MessageModel(
      {
        required this.senderID,
        required this.senderEmail,
        required this.receiverID,
        required this.message,
        required this.timestamp
      }
      );

  Map<String ,dynamic> toMap()
  {
    return
      {
        'senderID':senderID,
        'senderEmail' : senderEmail,
        'receiverID':receiverID,
        'message':message,
        'timestamp':timestamp,
      };
  }


}