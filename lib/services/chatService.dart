import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:test_chatapp/model.dart/chatModel.dart';

class chatServices {
  var ref = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;

  Future<void> sendMessage(String reciverId, String message) async {
    //get current userinfo
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmaill = auth.currentUser!.email.toString();
    var currentUserName = await ref
        .collection("users")
        .doc(currentUserId)
        .get()
        .then((value) => value.data()!['name']);
    final Timestamp time = Timestamp.now();
    //create new massage

    chatModel msg = chatModel(
        senderID: currentUserId,
        senderEmail: currentUserEmaill,
        receiverID: reciverId,
        message: message,
        senderName: currentUserName,
        time: time);

    //construct a chat room id and reciver id(shorted to ensure uniqueness)

    List<String> ids = [currentUserId, reciverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await ref
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(msg.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String oderUserId) {
    List<String> ids = [userId, oderUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return ref
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }
}
