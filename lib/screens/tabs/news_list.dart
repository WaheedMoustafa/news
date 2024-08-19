import 'package:flutter/material.dart';
import '../../data/api_manager.dart';
import '../../data/models/article.dart';
import '../../data/models/article_response.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class NewsList extends StatelessWidget {
  final Source source;

  const NewsList({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticleResponse>(
        future: ApiManager.getArticles(source.id!),
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

  Widget buildNewsList(List<Article> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => mapArticleToNewsWidget(list[index]));
  }

  Widget mapArticleToNewsWidget(Article article) {
    return Column(
      children: [
        Image.network(article.urlToImage ?? ""),
        Text(article.source?.name ?? ""),
        Text(article.title ?? ""),
        Text(article.publishedAt ?? "")
      ],
    );
  }
}