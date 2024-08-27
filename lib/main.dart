import 'package:flutter/material.dart';
import 'package:news/screens/home.dart';
import 'package:news/screens/tabs/search_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       initialRoute: Home.routeName,
      routes: {
         Home.routeName : (_)=> Home(),
        SearchList.routeName : (_)=> SearchList(),

      },

    );

  }
}
