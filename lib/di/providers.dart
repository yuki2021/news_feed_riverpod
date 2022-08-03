import 'package:flutter/material.dart';
import 'package:news_feed/models/db/dao.dart';
import 'package:news_feed/models/db/database.dart';
import 'package:news_feed/models/repository/news_repository.dart';
import 'package:news_feed/viewmodels/head_line_viewmodel.dart';
import 'package:news_feed/viewmodels/news_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels
];

List<SingleChildWidget> independentModels = [
  Provider<MyDatabase>(
    create: (_) => MyDatabase(),
    dispose: (_, db) => db.close(),
  )
];

List<SingleChildWidget> dependentModels = [
  ProxyProvider<MyDatabase, NewsDao>(
    update: (_, db, dao) => NewsDao(db),
  ),
  ProxyProvider<NewsDao, NewsRepository>(
    update: (_, dao, repository) =>
        NewsRepository(dao: dao),
  )
];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<HeadLineViewModel>(
    create: (context) => HeadLineViewModel(
      //repository: Provider.of<NewsRepository>(context, listen: false),
      repository: context.read<NewsRepository>(),
    ),
  ),
  ChangeNotifierProvider<NewsListViewModel>(
    create: (context) => NewsListViewModel(
      //repository: Provider.of<NewsRepository>(context, listen: false),
      repository: context.read<NewsRepository>(),
    ),
  )
];
