import 'package:ecommerceapp/Home/pages/bag.dart';
import 'package:ecommerceapp/Home/pages/setting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Home/home.dart';
import 'Log/login.dart';
import 'Log/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        'login': (context) => Login(),
        'register': (context) => Register(),
        'home': (context) => Home(),
        'bag': (context) => Bag(),
        'setting': (context) => Setting(),
      },
    );
  }
}
