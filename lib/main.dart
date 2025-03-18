import 'package:flutter/material.dart';
import 'Home/home_page.dart';
import 'main_page.dart';
void main() {
  runApp(  MyApp());
}
 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}