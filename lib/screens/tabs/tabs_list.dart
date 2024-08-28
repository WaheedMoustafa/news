import 'package:flutter/material.dart';
import 'package:news/screens/tabs/tab_view_model.dart';
import 'package:provider/provider.dart';
import '../../data/api_manager.dart';
import '../../data/base.dart';
import '../../data/models/article_response.dart';
import '../../data/models/source_response.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'news_list.dart';



class TabsList extends StatefulWidget {
  final String categoryId;

  const TabsList(this.categoryId, {super.key});

  @override
  State<TabsList> createState() => _TabsListState();
}

class _TabsListState extends State<TabsList> {
  TabsViewModel viewModel = TabsViewModel();
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    viewModel.getSources(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel,
      builder: (context, _) {
        viewModel = Provider.of(context);
        if (viewModel.sourcesApiState is BaseLoadingState) {
          return const LoadingView();
        } else if (viewModel.sourcesApiState is BaseErrorState) {
          String errorMessage =
              (viewModel.sourcesApiState as BaseErrorState).errorMessage;
          return ErrorView(error: errorMessage, onRetryClick: () {});
        } else {
          List<Sources> sources =
              (viewModel.sourcesApiState as BaseSuccessState<List<Sources>>)
                  .data;
          return buildTabsList(sources);
        }
      },
    );

  }

  Widget buildTabsList(List<Sources> sources) {
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

  Widget mapSourceToTab(Sources source, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xff39A552), width: 3),
          color: isSelected ? const Color(0xff39A552) : Colors.white),
      child: Text(
        source.name ?? "",
        style: TextStyle(color: isSelected ? Colors.white : const Color(0xff39A552)),
      ),
    );
  }
}