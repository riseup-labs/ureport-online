import 'dart:convert';
import 'response_opinions.dart' as questionArray;

class ResultOpinionLocal {
  ResultOpinionLocal({
    required this.id,
    required this.title,
    required this.org,
    required this.category,
    required this.polldate,
    required this.questions,
    required this.questionList,
  });

  int id;
  String title;
  dynamic org;
  String category;
  String? questions;
  String polldate;
  List<questionArray.Question>? questionList;

  factory ResultOpinionLocal.fromJson(Map<String, dynamic> json) =>
      ResultOpinionLocal(
        id: json["id"],
        title: json["title"],
        org: json["org"],
        category: json["category"],
        polldate: json["poll_date"],
        questions: json["questions"],
        questionList: json["questionsL"],
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
