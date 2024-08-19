import 'package:flutter/material.dart';
import '../../data/api_manager.dart';
import '../../data/models/article_response.dart';
import '../../data/models/source_response.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'news_list.dart';


class TabsList extends StatefulWidget {
  const TabsList({super.key});

  @override
  State<TabsList> createState() => _TabsListState();
}

class _TabsListState extends State<TabsList> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SourceResponse>(
        future: ApiManager.getSources(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error.toString(), onRetryClick: (){});
          } else if (snapshot.hasData) {
            return buildTabsList(snapshot.data!.sources!);
          } else {
            return const LoadingView();
          }
        });
  }

  Widget buildTabsList(List<Source> sources) {
    List<Widget> tabs = sources
        .map((source) =>
        mapSourceToTab(source, selectedTabIndex == sources.indexOf(source)))
        .toList();
    List<Widget> tabsBody = sources
        .map((source) => NewsList(source: source))
        .toList();
    return DefaultTabController(
      length: sources.length,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          TabBar(
            tabs: tabs,
            onTap: (index) {
              selectedTabIndex = index;
              setState(() {});
            },
            isScrollable: true,
            indicatorColor: Colors.transparent,
          ),
          Expanded(child: TabBarView(children: tabsBody))
        ],
      ),
    );
  }

  Widget mapSourceToTab(Source source, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.blue, width: 3),
          color: isSelected ? Colors.blue : Colors.white),
      child: Text(
        source.name ?? "",
        style: TextStyle(color: isSelected ? Colors.white : Colors.blue),
      ),
    );
  }
}