import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? email;
  String? uid;
  String? pass;

  void getInfo() async {
    var auth = FirebaseAuth.instance;
    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['name'];
        email = value.data()!['email'];
        uid = value.data()!['uid'];
        pass = value.data()!['pass'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name: "),
                    Text("${name.toString() ?? 'N/A'}"),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Email: "),
                    Text("${email.toString() ?? 'N/A'}"),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UID: "),
                    Expanded(
                      child: Text(
                        "${uid.toString() ?? 'N/A'}",
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Password: "),
                    Text("${pass.toString() ?? 'N/A'}"),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back"))
          ],
        ),
      ),
    )));
  }
}
