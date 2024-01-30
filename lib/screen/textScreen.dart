import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_chatapp/services/chatService.dart';

class TextScreen extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? reciverId;
  const TextScreen(
      {super.key, this.userName, required this.email, required this.reciverId});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  var message = TextEditingController();
  var ref = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  var chat = chatServices();
  void sendMsg() async {
    if (message.text.isNotEmpty) {
      await chat.sendMessage(
          widget.reciverId.toString(), message.text.toString());
      message.clear();
    }
  }

  var mesgId;
  void sendEmoji(var emoji, id) async {
    if (emoji != null) {
      var ids = [auth.currentUser!.uid, widget.reciverId];
      ids.sort();
      var chatRoomId = ids.join("_");
      await FirebaseFirestore.instance
          .collection('chat_room')
          .doc(chatRoomId)
          .collection('messages')
          .doc(id)
          .update({'msgemoji': emoji}).then((value) {
        print("emoji sent");
        print(emoji);
      });
    }
  }

  @override
  var selectedEmoji;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: ListTile(
          title: Text(widget.email!),
        )),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
                child: Column(
              children: [
                Expanded(child: buildMessageLiss()),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: message,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Message',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          sendMsg();
                        },
                        icon: const Icon(Icons.send))
                  ],
                )
              ],
            )),
          ),
        ));
  }

  Widget buildMessageLiss() {
    return StreamBuilder(
      stream: chat.getMessages(auth.currentUser!.uid, widget.reciverId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((e) {
            return buildMessageItem(e);
          }).toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot e) {
    Map<String, dynamic> data = e.data() as Map<String, dynamic>;

    // Check if the current user is the sender
    bool isCurrentUser = data['senderEmail'] == auth.currentUser!.email;

    // Determine the alignment based on the sender
    var align = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: align,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: InkWell(
              onDoubleTap: () {
                sendEmoji("", e.id);
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
                        content: Row(
                          children: [
                            Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedEmoji = "👍";

                                        sendEmoji(selectedEmoji, e.id);
                                      });
                                    },
                                    child: Text("👍"))),
                            Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedEmoji = "👎";

                                        sendEmoji(selectedEmoji, e.id);
                                      });
                                    },
                                    child: Text("👎"))),
                            Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedEmoji = "😂";
                                        sendEmoji(selectedEmoji, e.id);
                                      });
                                    },
                                    child: Text("😂"))),
                            Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedEmoji = "😢";

                                        sendEmoji(selectedEmoji, e.id);
                                      });
                                    },
                                    child: Text("😢"))),
                            Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedEmoji = "😡";

                                        sendEmoji(selectedEmoji, e.id);
                                      });
                                    },
                                    child: Text("😡"))),
                          ],
                        ),
                      );
                    });
              
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: FractionalOffset.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: isCurrentUser
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['message'],
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(data['message'],
                                style: TextStyle(color: Colors.black)),
                          ),
                  ),
                  Positioned(
                      top: 25,
                      right: -3,
                      child: Text("${data['msgemoji'] ?? ''}"))
                ],
              ),
            ),
          ),
        ));
  }
}
