// To parse this JSON data, do
//
//     final responseOpinions = responseOpinionsFromJson(jsonString);

import 'dart:convert';

ResponseOpinions responseOpinionsFromJson(String str) => ResponseOpinions.fromJson(json.decode(str));

String responseOpinionsToJson(ResponseOpinions data) => json.encode(data.toJson());

class ResponseOpinions {
  ResponseOpinions({
    required this.count,
    required this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory ResponseOpinions.fromJson(Map<String, dynamic> json) => ResponseOpinions(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required this.id,
    required this.flowUuid,
    required this.title,
    required this.org,
    required this.category,
    required this.pollDate,
    required this.modifiedOn,
    required this.createdOn,
    required this.questions,
  });

  int id;
  String flowUuid;
  String title;
  int org;
  ResultCategory category;
  DateTime pollDate;
  DateTime modifiedOn;
  DateTime createdOn;
  List<Question> questions;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    flowUuid: json["flow_uuid"],
    title: json["title"],
    org: json["org"],
    category: ResultCategory.fromJson(json["category"]),
    pollDate: DateTime.parse(json["poll_date"]),
    modifiedOn: DateTime.parse(json["modified_on"]),
    createdOn: DateTime.parse(json["created_on"]),
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "flow_uuid": flowUuid,
    "title": title,
    "org": org,
    "category": category.toJson(),
    "poll_date": pollDate.toIso8601String(),
    "modified_on": modifiedOn.toIso8601String(),
    "created_on": createdOn.toIso8601String(),
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class ResultCategory {
  ResultCategory({
    this.imageUrl,
    required this.name,
  });

  dynamic imageUrl;
  String name;

  factory ResultCategory.fromJson(Map<String, dynamic> json) => ResultCategory(
    imageUrl: json["image_url"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "image_url": imageUrl,
    "name": name,
  };
}

class Question {
  Question({
    required this.id,
    required this.rulesetUuid,
    required this.title,
    required this.results,
    required this.resultsByAge,
    required this.resultsByGender,
    required this.resultsByLocation,
  });

  int id;
  String rulesetUuid;
  String title;
  Results results;
  List<Results> resultsByAge;
  List<Results> resultsByGender;
  List<ResultsByLocation> resultsByLocation;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    rulesetUuid: json["ruleset_uuid"],
    title: json["title"],
    results: Results.fromJson(json["results"]),
    resultsByAge:json["results_by_age"]!=null? List<Results>.from(json["results_by_age"].map((x) => Results.fromJson(x))):<Results>[],
    resultsByGender: json["results_by_gender"]!=null?List<Results>.from(json["results_by_gender"].map((x) => Results.fromJson(x))):<Results>[],
    resultsByLocation:json["results_by_location"]!=null? List<ResultsByLocation>.from(json["results_by_location"].map((x) => ResultsByLocation.fromJson(x))):<ResultsByLocation>[],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ruleset_uuid": rulesetUuid,
    "title": title,
    "results": results.toJson(),
    "results_by_age": List<dynamic>.from(resultsByAge.map((x) => x.toJson())),
    "results_by_gender": List<dynamic>.from(resultsByGender.map((x) => x.toJson())),
    "results_by_location": List<dynamic>.from(resultsByLocation.map((x) => x.toJson())),
  };
}

class Results {
  Results({
    required this.openEnded,
    required this.resultsSet,
    required this.unset,
    required this.categories,
    required this.label,
  });

  bool openEnded;
  int resultsSet;
  int unset;
  List<CategoryElement> categories;
  String label;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    openEnded: json["open_ended"] == null ? false : json["open_ended"],
    resultsSet: json["set"],
    unset: json["unset"],
    categories: List<CategoryElement>.from(json["categories"].map((x) => CategoryElement.fromJson(x))),
    label: json["label"] == null ? "" : json["label"],
  );

  Map<String, dynamic> toJson() => {
    "open_ended": openEnded == null ? null : openEnded,
    "set": resultsSet,
    "unset": unset,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "label": label == null ? null : label,
  };
}

class CategoryElement {
  CategoryElement({
    required this.count,
    required this.label,
  });

  int count;
  String label;

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    count: json["count"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "label": label,
  };
}

class ResultsByLocation {
  ResultsByLocation({
    required this.openEnded,
    required this.resultsByLocationSet,
    required this.unset,
    required this.boundary,
    required this.label,
    required this.categories,
  });

  bool openEnded;
  int resultsByLocationSet;
  int unset;
  String boundary;
  String label;
  List<CategoryElement> categories;

  factory ResultsByLocation.fromJson(Map<String, dynamic> json) => ResultsByLocation(
    openEnded: json["open_ended"],
    resultsByLocationSet: json["set"],
    unset: json["unset"],
    boundary: json["boundary"],
    label: json["label"],
    categories: List<CategoryElement>.from(json["categories"].map((x) => CategoryElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "open_ended": openEnded,
    "set": resultsByLocationSet,
    "unset": unset,
    "boundary": boundary,
    "label": label,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}
