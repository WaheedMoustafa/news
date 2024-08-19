import 'package:flutter/material.dart';
import 'package:news/screens/tabs/tabs_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String routeName = 'home' ;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: TabsList(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("News app"),
      centerTitle: true,
    );
  }
}
