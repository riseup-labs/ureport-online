import 'dart:convert';

class ResultOpinionLocal {


  ResultOpinionLocal({
    required this.id,
    required this.title,
    required this.org,
    required this.category,
    required this.polldate,
    required this.questions,
  });


  int id;
  String title;
  dynamic org;
  String category;
  String questions;
  String polldate;

  factory ResultOpinionLocal.fromJson(Map<String, dynamic> json) =>
      ResultOpinionLocal(
        id: json["id"],
        title: json["title"],
        org: json["org"],
        category: json["category"],
        polldate: json["poll_date"],
        questions: json["questions"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "org": org,
        "category": category,
        "poll_date": polldate,
        "questions": questions,
      };
}
