// To parse this JSON data, do
//
//     final responseAbout = responseAboutFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ResponseAbout responseAboutFromJson(String str) => ResponseAbout.fromJson(json.decode(str));

String responseAboutToJson(ResponseAbout data) => json.encode(data.toJson());

class ResponseAbout {
  ResponseAbout({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory ResponseAbout.fromJson(Map<String, dynamic> json) => ResponseAbout(
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
    required this.org,
    required this.dashblockType,
    required this.priority,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.color,
    required this.path,
    required this.videoId,
    required this.tags,
  });

  int id;
  int org;
  String dashblockType;
  int priority;
  String title;
  String summary;
  String content;
  String imageUrl;
  dynamic color;
  dynamic path;
  dynamic videoId;
  dynamic tags;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    org: json["org"],
    dashblockType: json["dashblock_type"],
    priority: json["priority"],
    title: json["title"],
    summary: json["summary"],
    content: json["content"],
    imageUrl: json["image_url"],
    color: json["color"],
    path: json["path"],
    videoId: json["video_id"],
    tags: json["tags"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "org": org,
    "dashblock_type": dashblockType,
    "priority": priority,
    "title": title,
    "summary": summary,
    "content": content,
    "image_url": imageUrl,
    "color": color,
    "path": path,
    "video_id": videoId,
    "tags": tags,
  };
}
