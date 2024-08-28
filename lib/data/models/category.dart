import 'package:flutter/material.dart';

class Category {
  String backEndId;
  String title;
  String imagePath;
  bool isLeftSided;
  Color backgroundColor;

  Category(
      {required this.backEndId,
        required this.title,
        required this.imagePath,
        required this.isLeftSided,
        required this.backgroundColor});

  static List<Category> categories = [
    Category(
        backEndId: "sports",
        title: "Sports",
        imagePath: "assets/ball.png",
        isLeftSided: true,
        backgroundColor: Colors.red[900]!),
    Category(
        backEndId: "technology",
        title: "Technology",
        imagePath: "assets/Politics.png",
        isLeftSided: false,
        backgroundColor: Colors.blue[900]!),
    Category(
        backEndId: "health",
        title: "Health",
        imagePath: "assets/health.png",
        isLeftSided: true,
        backgroundColor: Colors.pink),
    Category(
        backEndId: "business",
        title: "Business",
        imagePath: "assets/bussines.png",
        isLeftSided: false,
        backgroundColor: Colors.orange[900]!),
    Category(
        backEndId: "entertainment",
        title: "Entertainment",
        imagePath: "assets/environment.png",
        isLeftSided: true,
        backgroundColor: Colors.lightBlue),
    Category(
        backEndId: "science",
        title: "Science",
        imagePath: "assets/science.png",
        isLeftSided: false,
        backgroundColor: Colors.yellow[500]!)
  ];
}