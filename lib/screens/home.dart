import 'package:flutter/material.dart';
import 'package:news/data/api_manager.dart';
import 'package:news/screens/tabs/search_list.dart';
import 'package:news/screens/tabs/tabs_list.dart';

import '../widgets/text_controller_arg.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String routeName = 'home' ;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearch = false ;
  final TextEditingController searchController = TextEditingController();
  List searched = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(67),
            child: isSearch ?   buildSearchAppBar() :buildAppBar()
        ),
        body: const TabsList(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff39A552),
      leading: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: InkWell(
            child: const Icon(Icons.menu,color: Colors.white,size: 40,),
          onTap: (){},
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: InkWell(
              onTap: (){
                isSearch = true ;
                setState(() {});
              },
              child: const Icon(Icons.search , color: Colors.white,size: 40,)),
        )
      ],
      title: const Text("News app",style: TextStyle(color: Colors.white,fontSize: 29),),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(50),
        )
      ),
    );
  }

  AppBar buildSearchAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff39A552),
      title: TextField(
        controller: searchController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white)
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: InkWell(
            child: const Icon(Icons.close, color: Color(0xff39A552),) ,
            onTap: (){isSearch = false ; setState(() {
          });},),
          suffixIcon: InkWell(child: const Icon(Icons.search , color: Color(0xff39A552),) ,
            onTap: (){
            Navigator.pushReplacementNamed(context, SearchList.routeName , arguments: TextControllerArg(searchController.text.trim()));}),
        ),

      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          )
      ),
    );
  }
}

// Container(
//         height: 25,
//           width: 200,
//           color: Colors.white,
//           child: Row(
//             children: [
//               InkWell(
//                 child: const Icon(Icons.close , color: Color(0xff39A552),),
//                 onTap: (){
//                   isSearch = false ;
//                   setState(() {
//                   });
//                 },
//               ),
//               const TextField(),
//               InkWell(
//                   onTap: (){},
//                   child: const Icon(Icons.search,color: Color(0xff39A552) ,))
//             ],
//           )),