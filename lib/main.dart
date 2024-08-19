import 'package:flutter/material.dart';
import 'package:news/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       initialRoute: Home.routeName,
      routes: {
         Home.routeName : (_)=> Home(),

      },

    );

  }
}
