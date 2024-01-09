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
  String questions;
  String polldate;
  List<questionArray.Question> questionList;

  factory ResultOpinionLocal.fromJson(Map<String, dynamic> json) =>
      ResultOpinionLocal(
        id: json["id"] == null ? 0 : json["id"],
        title: json["title"] == null ? "" : json["title"],
        org: json["org"],
        category: json["category"],
        polldate: json["poll_date"] == null ? "" : json["poll_date"],
        questions: json["questions"] == null ? "" : json["questions"],
        questionList: json["questionsL"] == null ? [] : json["questionsL"],
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
