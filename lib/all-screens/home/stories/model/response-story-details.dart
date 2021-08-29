
import 'dart:convert';

ResponseStoryDetails responseStoryDetailsFromJson(String str) => ResponseStoryDetails.fromJson(json.decode(str));

String responseStoryDetailsToJson(ResponseStoryDetails data) => json.encode(data.toJson());

class ResponseStoryDetails {
  ResponseStoryDetails({
    required this.id,
    required this.title,
    required this.featured,
    required this.summary,
    required this.content,
    this.videoId,
    this.audioLink,
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
  String content ="";
  dynamic videoId;
  dynamic audioLink;
  String tags;
  int org;
  List<String> images;
  Category category;
  DateTime createdOn;

  factory ResponseStoryDetails.fromJson(Map<String, dynamic> json) => ResponseStoryDetails(
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
    "video_id": videoId,
    "audio_link": audioLink,
    "tags": tags,
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
    imageUrl: json["image_url"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "image_url": imageUrl,
    "name": name,
  };
}
