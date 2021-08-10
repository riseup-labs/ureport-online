// To parse this JSON data, do
//
//     final responseContactCreation = responseContactCreationFromJson(jsonString);

import 'dart:convert';

ResponseContactCreation responseContactCreationFromJson(String str) => ResponseContactCreation.fromJson(json.decode(str));

String responseContactCreationToJson(ResponseContactCreation data) => json.encode(data.toJson());

class ResponseContactCreation {
  ResponseContactCreation({
    required this.contactUuid,
  });

  String contactUuid;

  factory ResponseContactCreation.fromJson(Map<String, dynamic> json) => ResponseContactCreation(
    contactUuid: json["contact_uuid"] == null ? null : json["contact_uuid"],
  );

  Map<String, dynamic> toJson() => {
    "contact_uuid": contactUuid == null ? null : contactUuid,
  };
}
