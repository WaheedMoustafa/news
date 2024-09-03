import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/data/api_manager.dart';
import 'package:news/data/models/search_response.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: library_prefixes
import 'package:timeago/timeago.dart' as timeAgo;

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  static const String routeName = 'search view';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool isClicked = false;
  TextEditingController searchController = TextEditingController();

  Future<void> getSearchedNes(String query) async {
    try {
      SearchResponse searchResponse = await ApiManager.getSearch(query);
      if (searchResponse.articles != null) {
        setState(() {
          articlesList = searchResponse.articles!;
        });
      } else {
        // Handle the case where articles are null
        setState(() {
          articlesList = [];
        });
      }
    } catch (error) {
      // Handle any errors that occur during the fetch
      print('Error fetching searched news: $error');
      setState(() {
        articlesList = [];
      });
    }
  }

  getSearchedNews(String query) async {
    SearchResponse searchResponse = await ApiManager.getSearch(query);
    articlesList = searchResponse.articles!;
    setState(() {});
    return searchResponse.articles;
  }

  List<Articles> articlesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {},
                    onSubmitted: (value) {
                      getSearchedNews(searchController.text);
                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        suffixIcon: IconButton(
                          onPressed: () {
                            getSearchedNews(searchController.text);
                          },
                          icon: const Opacity(
                            opacity: .8,
                            child: Icon(
                              Icons.search,
                              size: 28,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white))),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
                child: articlesList.isEmpty
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: articlesList.length,
                    itemBuilder: (context, index) =>
                        mapArticleToNewsWidget(articlesList[index]),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  mapArticleToNewsWidget(Articles article) {
    if (isClicked == false) {
      return InkWell(
        onTap: () {
          isClicked = !isClicked;
          setState(() {});
        },
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? "https://placehold.co/600x400",
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article.source?.name ?? "",
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Text(
              article.title ?? "",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 200,
                ),
                Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Text(formatTimeAgo(article.publishedAt ?? ""),
                        style: const TextStyle(color: Colors.grey))),
              ],
            ),
          ],
        ),
      );
    } else if (isClicked == true) {
      return InkWell(
        onTap: () {
          isClicked = !isClicked;
          setState(() {});
        },
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: article.urlToImage ?? "https://placehold.co/600x400",
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article.source?.name ?? "",
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Text(
              article.title ?? "",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 200,
                ),
                Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      formatTimeAgo(
                        article.publishedAt ?? "",
                      ),
                      style: const TextStyle(color: Colors.grey),
                    )),
              ],
            ),
            Text(article.content ?? ""),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                      onTap: () {
                        launchURL(article.url ?? "");
                      },
                      child: const Text(
                        'View Full Article',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  formatTimeAgo(String dateString) {
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
