import 'dart:convert';

ResponseStories responseStoriesFromJson(String str) =>
    ResponseStories.fromJson(json.decode(str));

String responseStoriesToJson(ResponseStories data) =>
    json.encode(data.toJson());

class ResponseStories {
  ResponseStories({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory ResponseStories.fromJson(Map<String, dynamic> json) =>
      ResponseStories(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
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

  int id;
  String title;
  bool featured;
  String summary;
  String content;
  String videoId;
  String audioLink;
  String tags;
  int org;
  List<String> images;
  Category category;
  DateTime createdOn;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        featured: json["featured"],
        summary: json["summary"],
        content: json["content"],
        videoId: json["video_id"] == null ? "null" : json["video_id"],
        audioLink: json["audio_link"] == null ? "null" : json["audio_link"],
        tags: json["tags"] == null ? "null" : json["tags"],
        org: json["org"],
        images: List<String>.from(json["images"].map((x) => x)),
        category: Category.fromJson(json["category"]),
        createdOn: DateTime.parse(json["created_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "featured": featured,
        "summary": summary,
        "content": content,
        "video_id": videoId == null ? null : videoId,
        "audio_link": audioLink == null ? null : audioLink,
        "tags": tags == null ? null : tags,
        "org": org,
        "images": List<dynamic>.from(images.map((x) => x)),
        "category": category.toJson(),
        "created_on": createdOn.toIso8601String(),
      };
}

class Category {
  Category({
    required this.imageUrl,
    required this.name,
  });

  String imageUrl;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        imageUrl: json["image_url"] == null ? "" : json["image_url"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "name": name,
      };
}
