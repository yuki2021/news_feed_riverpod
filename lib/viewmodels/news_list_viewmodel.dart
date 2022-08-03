import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/models/repository/news_repository.dart';

final newsListViewModelProvider = StateNotifierProvider.autoDispose<NewsListViewModel, List<Article>>(
    (ref) {
      return NewsListViewModel(ref.read);
    }
);

class NewsListViewModel extends StateNotifier<List<Article>> {

  final Reader read;
  NewsListViewModel(this.read) : super([]);

  SearchType _searchType = SearchType.CATEGORY;
  SearchType get searchType => _searchType;

  Category _category = categories[0];
  Category get category => _category;

  String _keyword = "";
  String get keyword => _keyword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  Future<void> getNews(
      {required SearchType searchType, String? keyword, Category? category}) async {

    final newsRepository = read(newsRepositoryProvider);

    _searchType = searchType;
    _keyword = keyword ?? _keyword;
    _category = category ?? _category;

    _isLoading = true;

    _articles = await newsRepository.getNews(
      searchType: _searchType,
      keyword: _keyword,
      category: _category,
    );

    //print("articles: $_articles");
    print("searchType: $_searchType / keyword: $_keyword / category: $_category / articles: ${_articles[0].title}");

    state = _articles;

    _isLoading = false;
  }
}
