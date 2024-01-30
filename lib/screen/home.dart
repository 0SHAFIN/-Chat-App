import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_chatapp/screen/login.dart';
import 'package:test_chatapp/screen/profile.dart';
import 'package:test_chatapp/screen/textScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // void getData() async {
  //   var ref = FirebaseFirestore.instance.collection('users');
  //   var data = await ref.get();
  //   data.docs.forEach((element) {
  //     print(element.data());
  //   });
  // }
  var ref = FirebaseFirestore.instance.collection('users').snapshots();
  var auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: ListTile(
                    title: Text("Name"),
                    subtitle: Text("Email"),
                  )),
              ListTile(
                title: const Text("Profile"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              ListTile(
                title: const Text("Logout"),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  });
                },
              )
            ],
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to Home Page",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                  stream: ref,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data =
                              e.data() as Map<String, dynamic>;
                          if (data['email'] != auth.currentUser!.email) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TextScreen(
                                                userName: data['name'],
                                                email: data['email'],
                                                reciverId: data['uid'],
                                              )));
                                },
                                title: Text(data['name']),
                                subtitle: Text(data['email']),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }).toList(),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        )));
  }
}
