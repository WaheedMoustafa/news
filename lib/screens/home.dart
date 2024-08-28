import 'package:flutter/material.dart';
import 'package:news/data/api_manager.dart';
import 'package:news/screens/tabs/category/category_list.dart';
import 'package:news/screens/tabs/search_list.dart';
import 'package:news/screens/tabs/settings.dart';
import 'package:news/screens/tabs/tabs_list.dart';
import '../data/models/category.dart';
import '../widgets/text_controller_arg.dart';


class Home extends StatefulWidget {
  static const String routeName = "home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Widget currentWidgetBody;
  bool isSearch = false ;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentWidgetBody = CategoriesTab(onCategoryClick);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (currentWidgetBody is CategoriesTab) {
            return true;
          } else {

            currentWidgetBody = CategoriesTab(onCategoryClick);
            setState(() {});
            return false;
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(67),
              child: isSearch ?   buildSearchAppBar() :buildAppBar()
          ),
          body: currentWidgetBody,
          drawer: buildDrawer(),
        ),
      ),
    );
  }

  void onCategoryClick(Category category) {
    currentWidgetBody = TabsList(category.backEndId);
    setState(() {});
  }

  buildDrawer() => Drawer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildDrawerHeader(),
        buildDrawerRow(Icons.settings, "Settings", () {
          currentWidgetBody = SettingsTab();
          Navigator.pop(context);
          setState(() {});
        }),
        buildDrawerRow(Icons.list, "Categories", () {
          currentWidgetBody = CategoriesTab(onCategoryClick);
          Navigator.pop(context);
          setState(() {});
        })
      ],
    ),
  );

  Widget buildDrawerHeader() => Container(
      color: Colors.blue,
      height: MediaQuery.of(context).size.height * .15,
      child: const Center(
          child: Text(
            "NewsApp",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24),
          )));

  buildDrawerRow(IconData iconData, String title, void Function() onClick) =>
      InkWell(
        onTap: () {
          onClick();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 34,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

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




