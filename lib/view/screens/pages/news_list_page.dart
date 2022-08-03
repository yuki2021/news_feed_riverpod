import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/view/components/article_tile.dart';
import 'package:news_feed/view/components/category_chips.dart';
import 'package:news_feed/view/components/search_bar.dart';
import 'package:news_feed/view/screens/news_web_page_screen.dart';
import 'package:news_feed/viewmodels/news_list_viewmodel.dart';

class NewsListPage extends ConsumerWidget {



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(newsListViewModelProvider.notifier);
    List<Article> _articles = ref.watch(newsListViewModelProvider);

    if (!viewModel.isLoading && viewModel.articles.isEmpty) {

      // viewModel.getNews(
      //     searchType: SearchType.CATEGORY, category: categories[0]);
      Future(() => viewModel.getNews(
          searchType: SearchType.CATEGORY, category: categories[0]));
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          tooltip: "更新",
          onPressed: () => onRefresh(ref),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SearchBar(
                onSearch: (keyword) => getKeywordNews(ref, keyword),
              ),
              CategoryChips(
                onCategorySelected: (category) =>
                    getCategoryNews(ref, category),
              ),
              //記事表示
              Expanded(
                child: viewModel.isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : ListView.builder(
                      itemCount: _articles.length,
                      itemBuilder: (context, int position) => ArticleTile(
                        article: _articles[position],
                        onArticleClicked: (article) =>
                            _openArticleWebPage(article, context),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh(WidgetRef ref) async {
    final viewModel = ref.watch(newsListViewModelProvider.notifier);
    await viewModel.getNews(
      searchType: viewModel.searchType,
      keyword: viewModel.keyword,
      category: viewModel.category,
    );
    print("NewsListPage.onRefresh");
  }

  Future<void> getKeywordNews(WidgetRef ref, keyword) async {
    final viewModel = ref.watch(newsListViewModelProvider.notifier);
    await viewModel.getNews(
      searchType: SearchType.KEYWORD,
      keyword: keyword,
      category: categories[0],
    );
    print("NewsListPage.getKeywordNews");
  }

  Future<void> getCategoryNews(WidgetRef ref, Category category) async {
    print("NewsListPage.getCategoryNews / category: ${category.nameJp}");
    //final viewModel = Provider.of<NewsListViewModel>(context, listen: false);
    final viewModel = ref.watch(newsListViewModelProvider.notifier);
    await viewModel.getNews(
      searchType: SearchType.CATEGORY,
      category: category,
    );
  }

  _openArticleWebPage(Article article, BuildContext context) {
    print("_openArticleWebPage: ${article.url}");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsWebPageScreen(
          article: article,
        )));
  }
}
