import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/api_manager.dart';
import '../../data/models/article_response.dart';
import '../../data/models/source_response.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class NewsList extends StatefulWidget {
  final Sources source;

   const NewsList({super.key, required this.source});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  bool isClicked = false ;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticleResponse>(
        future: ApiManager.getArticles(widget.source.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorView(
                error: snapshot.error.toString(), onRetryClick: () {});
          } else if (snapshot.hasData) {
            return buildNewsList(snapshot.data!.articles!);
          } else {
            return const LoadingView();
          }
        });
  }

  Widget buildNewsList(List<Articles> list) {
    return ListView.builder(
        itemCount:list.length ,
        itemBuilder: (context, index) => mapArticleToNewsWidget(list[index]));
  }

   mapArticleToNewsWidget(Articles article) {
    if(isClicked == false){
      return InkWell(
        onTap: (){
          isClicked = !isClicked ;
          setState(() {

          });
        },
        child: Column(
          children: [
            Image.network(article.urlToImage ?? ""),
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
      );
    }
    else if(isClicked == true){
    return InkWell(
      onTap: (){
        isClicked = !isClicked ;
        setState(() {

        });
      },
      child: Column(
        children: [
          Image.network(article.urlToImage ?? ""),
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