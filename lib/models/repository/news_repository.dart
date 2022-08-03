import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/db/dao.dart';
import 'package:news_feed/models/db/database.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:provider/provider.dart';
import 'package:news_feed/main.dart';
import 'package:news_feed/util/extensions.dart';

//TODO httpパッケージのimport
import 'package:http/http.dart' as http;

/*
* httpを使ったWeb通信（Flutterの公式リファレンスを使おう）
* Fetch data from the internet
* https://flutter.dev/docs/cookbook/networking/fetch-data
* */

class NewsRepository {
  static const BASE_URL = "https://newsapi.org/v2/top-headlines?country=jp";
  //TODO ご自分のAPIキーを入れて下さい。
  static const API_KEY = "977d1428acaa4e859fe2c429f52ec654";

  final NewsDao _dao;
  NewsRepository({dao, apiService}) : _dao = dao;

  Future<List<Article>> getNews({
    required SearchType searchType,
    String? keyword,
    Category? category,
  }) async {
    List<Article> result = [];

    http.Response? response;

    switch (searchType) {
      case SearchType.HEAD_LINE:
        //print("NewsRepository.getHeadLines");
        final requestUrl = Uri.parse(BASE_URL + "&apiKey=$API_KEY");
        response = await http.get(requestUrl);
        break;
      case SearchType.KEYWORD:
        final requestUrl = Uri.parse(BASE_URL + "&q=$keyword&pageSize=30&apiKey=$API_KEY");
        response = await http.get(requestUrl);
        break;
      case SearchType.CATEGORY:
        final requestUrl = Uri.parse(BASE_URL + "&category=${category?.nameEn}&apiKey=$API_KEY");
        response = await http.get(requestUrl);
        break;
    }
    //結果の判定はレスポンスコードで
    //https://developer.mozilla.org/ja/docs/Web/HTTP/Status
    // If the server did return a 200 OK response,
    // then parse the JSON.

    if (response.statusCode == 200) {
      final responseBody = response.body;

      result = await insertAndReadFromDB(jsonDecode(responseBody));

      //文字化けする場合
      // result = await insertAndReadFromDB(
      //     jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception("Failed to load news");
    }
    return result;
  }

  Future<List<Article>> insertAndReadFromDB(responseBody) async {
    //print(responseBody);

    final articles = News.fromJson(responseBody).articles;

    //Webから取得した記事リスト（Dartのモデルクラス：Article）をDBのテーブルクラス（Articles）に変換してDB登録・DBから取得
    final articleRecords =
    await _dao.insertAndReadNewsFromDB(articles.toArticleRecords(articles));

    //DBから取得したデータをモデルクラスに再変換して返す
    return articleRecords.toArticles(articleRecords);
  }
}
