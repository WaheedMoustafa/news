import 'package:flutter/cupertino.dart';
import '../../data/api_manager.dart';
import '../../data/base.dart';
import '../../data/models/search_response.dart';

class SearchViewModel extends ChangeNotifier {
  BaseApiState articlesApiState = BaseLoadingState();
  List<Articles> list = [];
  late Articles article ;


  getSearch(String query) async {
    try {

        articlesApiState = BaseLoadingState();
        notifyListeners();
      
      List<Articles> sources = (await ApiManager.getSearch(query)).articles!;
      if(article.title!.contains(query)){
        list.add(article);
      }



      articlesApiState = BaseSuccessState(list);
      notifyListeners();

    } catch (e) {
      articlesApiState = BaseErrorState(e.toString());
      notifyListeners();
    }
  }
}