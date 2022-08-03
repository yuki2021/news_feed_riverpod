import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable()
class News {
  final List<Article> articles;

  News({required this.articles});

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

@JsonSerializable()
class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  @JsonKey(name: "publishedAt")
  final String? publishDate;
  final String? content;

  Article(
      {this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishDate,
      this.content});

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  // //-------------------------------------------
  // Article copyWith({
  //   String? title,
  //   String? description,
  //   String? url,
  //   String? urlToImage,
  //   String? publishDate,
  //   String? content,
  // }) {
  //   return Article(
  //     title: title ?? this.title,
  //     description: description ?? this.description,
  //     url: url ?? this.url,
  //     urlToImage: urlToImage ?? this.urlToImage,
  //     publishDate: publishDate ?? this.publishDate,
  //     content: content ?? this.content,
  //   );
  // }
}
