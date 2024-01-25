import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_chatapp/screen/home.dart';
import 'package:test_chatapp/screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var user = FirebaseAuth.instance.currentUser;
    Timer(Duration(seconds: 3), () {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text(
        "Splash Screen",
        style: TextStyle(fontSize: 30),
      ),
    ));
  }
}
