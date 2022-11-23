import 'dart:convert';

import 'package:ureport_ecaro/all-screens/home/articles/article/model/article.dart';

Category responseCategoryFromJson(String str) =>
    Category.fromJson(json.decode(str));

String responseCategoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.img,
    required this.articles,
  });

  int id;
  String title;
  String description;
  String img;
  List<Article> articles;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        description: json["featured"],
        img: json["summary"],
        articles: List<Article>.from(json["articles"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "img": img,
        "articles": articles,
      };
}
