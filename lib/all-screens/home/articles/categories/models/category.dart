// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  final int? count;
  final String? next;
  final dynamic previous;
  final List<Result>? results;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        count: json["count"] == null ? null : json["count"],
        next: json["next"] == null ? null : json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count == null ? null : count,
        "next": next == null ? null : next,
        "previous": previous,
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.title,
    required this.featured,
    required this.summary,
    required this.content,
    required this.videoId,
    required this.audioLink,
    required this.tags,
    required this.org,
    required this.images,
    required this.category,
    required this.createdOn,
  });

  final int id;
  final String title;
  final bool featured;
  final String summary;
  final String content;
  final dynamic videoId;
  final dynamic audioLink;
  final String tags;
  final int org;
  final List<String> images;
  final CategoryClass category;
  final DateTime createdOn;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      id: json["id"] == null ? null : json["id"],
      title: json["title"] == null ? null : json["title"],
      featured: json["featured"] == null ? null : json["featured"],
      summary: json["summary"] == null ? null : json["summary"],
      content: json["content"] == null ? null : json["content"],
      videoId: json["video_id"],
      audioLink: json["audio_link"],
      tags: json["tags"] == null ? null : json["tags"],
      org: json["org"] == null ? null : json["org"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"].map((x) => x)),
      category: json["category"] == null
          ? CategoryClass()
          : CategoryClass.fromJson(json["category"]),
      createdOn: DateTime.parse(json["created_on"]));

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "featured": featured == null ? null : featured,
        "summary": summary == null ? null : summary,
        "content": content == null ? null : content,
        "video_id": videoId,
        "audio_link": audioLink,
        "tags": tags == null ? null : tags,
        "org": org == null ? null : org,
        "images":
            images == null ? null : List<dynamic>.from(images.map((x) => x)),
        "category": category == null ? null : category.toJson(),
        "created_on": createdOn == null ? null : createdOn.toIso8601String(),
      };
}

class CategoryClass {
  CategoryClass({
    this.imageUrl,
    this.name,
  });

  final String? imageUrl;
  final String? name;

  factory CategoryClass.fromJson(Map<String, dynamic> json) => CategoryClass(
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl == null ? null : imageUrl,
        "name": name == null ? null : name,
      };
}
