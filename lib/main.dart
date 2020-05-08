import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/screens/login_screen.dart';

void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));

  Firestore.instance.collection('users').document().setData({
    'text' : 'Hello World!'
  });

}