import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/screens/login_screen.dart';

void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
    theme: ThemeData(
      primaryColor: Color(0xff075e54),
      accentColor: Color(0xff25d366),
    ),
  ));



}