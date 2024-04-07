// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_firebase_sample/view/home_screen/home_screen.dart';
import 'package:task_firebase_sample/view/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key, this.isLogin = false});

  bool isLogin;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      if (widget.isLogin) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("WELCOME")),
    );
  }
}
