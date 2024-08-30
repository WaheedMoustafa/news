import 'dart:convert';
import 'package:http/http.dart';
import 'models/article_response.dart';
import 'models/search_response.dart';
import 'models/source_response.dart';


abstract class ApiManager{

  static const String _baseUrl  = 'https://newsapi.org';
  static const String _endPoint = '/v2/top-headlines/sources';
  static const String _apiKey =   'f2fea3abff744e8f8892375133c1ceb0' ;
  static const String _endPointArticle = '/v2/everything';

  static Future<SourceResponse> getSources (String categoryId) async{
    Response serverRes = await get(Uri.parse('$_baseUrl$_endPoint?apiKey=$_apiKey&category=$categoryId'));

    if(serverRes.statusCode >= 200 && serverRes.statusCode < 300){
      Map json = jsonDecode(serverRes.body) as Map;
      return SourceResponse.fromJson(json);
    } else{
      throw 'Something Went Wrong';
    }

  }

  static Future<ArticleResponse> getArticles (String sourceId, int page) async{
    Response serverRes = await get(Uri.parse('$_baseUrl$_endPointArticle?apiKey=$_apiKey&sources=$sourceId&page=$page&pageSize=10'));
    if(serverRes.statusCode >= 200 && serverRes.statusCode < 300){
      Map json = jsonDecode(serverRes.body) as Map;
      return ArticleResponse.fromJson(json);
    } else{
      throw 'Something Went Wrong';
    }

  }

  static Future<SearchResponse> getSearch (String q) async{
    Response serverRes = await get(Uri.parse('$_baseUrl$_endPointArticle?apiKey=$_apiKey&q=$q'));
    if(serverRes.statusCode >= 200 && serverRes.statusCode < 300){
      Map json = jsonDecode(serverRes.body) as Map;
      return SearchResponse.fromJson(json);
    } else{
      throw 'Something Went Wrong';
    }

  }
}