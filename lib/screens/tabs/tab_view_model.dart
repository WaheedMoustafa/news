import 'package:flutter/material.dart';
import 'package:news/data/models/source_response.dart';
import '../../data/api_manager.dart';
import '../../data/base.dart';
import 'package:news/data/models/category.dart';


class TabsViewModel extends ChangeNotifier {
  BaseApiState sourcesApiState = BaseLoadingState();

  getSources(String categoryId) async {
    try {
      sourcesApiState = BaseLoadingState();
      notifyListeners();
      List<Sources> sources = (await ApiManager.getSources(categoryId)).sources!;
      sourcesApiState = BaseSuccessState(sources);
      notifyListeners();
    } catch (e) {
      sourcesApiState = BaseErrorState(e.toString());
      notifyListeners();
    }
  }
}