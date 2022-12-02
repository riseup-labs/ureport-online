import 'dart:convert';

History responseHistoryFromJson(String str) =>
    History.fromJson(json.decode(str));

String responseHistoryToJson(History data) => json.encode(data.toJson());

class History {
  History({
    required this.id,
    required this.image,
    required this.topic,
    required this.title,
  });

  int id;
  String image;
  String topic;
  String title;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        title: json["title"],
        topic: json["topic"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "topic": topic,
        "image": image,
      };
}
