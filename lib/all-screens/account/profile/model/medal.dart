import 'dart:convert';

Medal responseMedalFromJson(String str) => Medal.fromJson(json.decode(str));

String responseMedalToJson(Medal data) => json.encode(data.toJson());

class Medal {
  Medal({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.isActive,
    this.acquiredDate,
  });

  int id;
  String image;
  String title;
  String description;
  bool isActive;
  DateTime? acquiredDate;

  factory Medal.fromJson(Map<String, dynamic> json) => Medal(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        isActive: json["isActive"],
        acquiredDate: json["author"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "isActive": isActive,
        "acquiredDate": acquiredDate ?? null,
      };
}
