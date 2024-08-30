import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/tabs/search_view_model.dart';
import 'package:news/widgets/text_controller_arg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/api_manager.dart';
import '../../data/base.dart';
import '../../data/models/search_response.dart';
import '../../data/models/source_response.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class SearchList extends StatefulWidget {

  const SearchList({super.key });

  static const String routeName = 'search list' ;

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  bool isClicked = false ;
  SearchViewModel searchViewModel = SearchViewModel() ;

  @override
  void initState() {
    super.initState();
    ModalRoute? modalRoute = ModalRoute.of(context);
    TextControllerArg arguments = modalRoute?.settings.arguments! as TextControllerArg;
    searchViewModel.getSearch(arguments.controller);
  }

  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
        create: (_) => searchViewModel,
        builder: (context, _) {
          searchViewModel = Provider.of(context);
          if (searchViewModel.articlesApiState is BaseLoadingState) {
            return const LoadingView();
          } else if (searchViewModel.articlesApiState is BaseErrorState) {
            String errorMessage =
                (searchViewModel.articlesApiState as BaseErrorState).errorMessage;
            return ErrorView(error: errorMessage, onRetryClick: () {});
          } else{
            List<Articles> sources =
                (searchViewModel.articlesApiState as BaseSuccessState<List<Articles>>)
                    .data;
            return buildNewsList(sources);
          }
        }
    );

   //   return FutureBuilder<SearchResponse>(
   //       future: ApiManager.getSearch(arguments.controller),
   //       builder: (context, snapshot) {
   //         if (snapshot.hasError) {
   //           return ErrorView(
   //               error: snapshot.error.toString(), onRetryClick: () {});
   //         } else if (snapshot.hasData) {
   //           return buildNewsList(snapshot.data!.articles!);
   //         } else {
   //           return const LoadingView();
   //         }
   //       });
    }


  Widget buildNewsList(List<Articles> list) {
    return ListView.builder(
        itemCount:list.length ,
        itemBuilder: (context, index) => mapArticleToNewsWidget(context,list[index]));
  }

  mapArticleToNewsWidget(BuildContext context,Articles article) {
    if(isClicked == false){
      return InkWell(
        onTap: (){
          isClicked = !isClicked ;
          setState(() {

          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 3),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: article.urlToImage ?? "",
                placeholder: (context, url) => LoadingView(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: MediaQuery.of(context).size.height * .25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(article.source?.name ?? "" ,
                    style: TextStyle(fontSize: 15,color: Colors.grey),),
                  const SizedBox(width: 20,),
                ],
              ),
              Text(article.title ?? "",
                style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600 ,color: Colors.black),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 200,),
                  Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      child: Text(formatTimeAgo(article.publishedAt ?? ""),style:  TextStyle(  color: Colors.grey))),
                ],
              ),
            ],
          ),
        ),
      );
    }
    else if(isClicked == true){
      return InkWell(
        onTap: (){
          isClicked = !isClicked ;
          setState(() {

          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 3),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: article.urlToImage ?? "",
                placeholder: (context, url) => LoadingView(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: MediaQuery.of(context).size.height * .25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(article.source?.name ?? "",style: TextStyle(fontSize: 15,color: Colors.grey),),
                  const SizedBox(width: 20,),
                ],
              ),
              Text(article.title ?? "",
                style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600 ,color: Colors.black),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 200,),
                  Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      child: Text(formatTimeAgo(article.publishedAt ?? "",),style:  TextStyle(  color: Colors.grey),)),
                ],
              ),
              Text(article.content ?? ""),
              Row(
                children: [
                  const SizedBox(width: 200,),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                        onTap: (){
                          launchURL(article.url?? "");
                        },
                        child: const Text('View Full Article',style: TextStyle(fontWeight: FontWeight.w700),)),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  String formatTimeAgo (String dateString){
    DateTime dateTime = DateTime.parse(dateString);
    return timeAgo.format(dateTime);
  }
  launchURL(String ur) async {
    final Uri url = Uri.parse(ur);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }


}
