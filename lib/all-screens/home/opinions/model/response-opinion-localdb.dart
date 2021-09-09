import 'dart:convert';

class ResultOpinionLocal {
  ResultOpinionLocal({
    required this.id,
    required this.title,
    required this.org,
    required this.category,
    required this.questions,
  });


  int id;
  String title;
  dynamic org;
  String category;
  String questions;

  factory ResultOpinionLocal.fromJson(Map<String, dynamic> json) =>
      ResultOpinionLocal(
        id: json["id"],
        title: json["title"],
        org: json["org"],
        category: json["category"],
        questions: json["questions"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "org": org,
        "category": category,
        "questions": questions,
      };
}
