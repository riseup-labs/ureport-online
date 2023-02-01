import 'dart:convert';

class ResultLocal {
  ResultLocal({
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
  String featured;
  String summary;
  String content;
  String videoId;
  String audioLink;
  String tags;
  int org;
  String images;
  String category;
  String createdOn;

  factory ResultLocal.fromJson(Map<String, dynamic> json) => ResultLocal(
        id: json["id"] == null ? 1 : json["id"],
        title: json["title"] == null ? "" : json["title"],
        featured: json["featured"] == null ? "" : json["featured"],
        summary: json["summary"] == null ? "" : json["summary"],
        content: json["content"] == null ? "" : json["content"],
        videoId: json["video_id"] == null ? "null" : json["video_id"],
        audioLink: json["audio_link"] == null ? "null" : json["audio_link"],
        tags: json["tags"] == null ? "null" : json["tags"],
        org: json["org"] == null ? 1 : json["org"],
        images: json["images"] == null ? "" : json["images"],
        category: json["category"] == null ? "" : json["category"],
        createdOn: json["created_on"] == null ? "" : json["created_on"],
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
        "images": images,
        "category": category,
        "created_on": createdOn,
      };
}
