import 'package:cloud_firestore/cloud_firestore.dart';

class chatModel {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;

  final String senderName;
  final Timestamp time;
  chatModel(
      {required this.senderID,
      required this.senderEmail,
      required this.receiverID,
      required this.message,
      required this.senderName,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'senderName': senderName,
      'time': time,
    };
  }
}
