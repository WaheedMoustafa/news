import 'package:flutter/cupertino.dart';
import 'package:news/data/models/article_response.dart';
import '../../data/api_manager.dart';
import '../../data/base.dart';

class NewsViewModel extends ChangeNotifier {
  BaseApiState articlesApiState = BaseLoadingState();
  List<Articles> list = [];

  getArticles(String sourceId , int page , {bool fromLoad = false}) async {
    try {
      if(fromLoad){

      }
      else {
        articlesApiState = BaseLoadingState();
        notifyListeners();
      }
        List<Articles> sources = (await ApiManager.getArticles(sourceId, page)).articles!;

        if(sources.isNotEmpty){
          list.addAll(sources);
        }

      articlesApiState = BaseSuccessState(list);
      notifyListeners();
    } catch (e) {
      articlesApiState = BaseErrorState(e.toString());
      notifyListeners();
    }
  }
}