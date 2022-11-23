import 'dart:convert';

Article responseCategoryFromJson(String str) =>
    Article.fromJson(json.decode(str));

String responseCategoryToJson(Article data) => json.encode(data.toJson());

class Article {
  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.img,
    required this.author,
    required this.createdAt,
  });

  int id;
  String title;
  String content;
  String type;
  String img;
  String author;
  DateTime createdAt;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        img: json["img"],
        type: json["type"],
        author: json["author"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "img": img,
        "type": type,
        "author": author,
        "createdAt": createdAt,
      };
}
