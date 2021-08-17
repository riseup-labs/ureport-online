// To parse this JSON data, do
//
//     final responseSingleContact = responseSingleContactFromJson(jsonString);

import 'dart:convert';

ResponseSingleContact responseSingleContactFromJson(String str) => ResponseSingleContact.fromJson(json.decode(str));

String responseSingleContactToJson(ResponseSingleContact data) => json.encode(data.toJson());

class ResponseSingleContact {
  ResponseSingleContact({
    this.next,
    this.previous,
    required this.results,
  });

  dynamic next;
  dynamic previous;
  List<Result> results;

  factory ResponseSingleContact.fromJson(Map<String, dynamic> json) => ResponseSingleContact(
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required this.uuid,
    this.name,
    this.language,
    required this.urns,
    required this.groups,
    required this.fields,
    required this.blocked,
    required this.stopped,
    required this.createdOn,
    required this.modifiedOn,
    this.lastSeenOn,
  });

  String uuid;
  dynamic name;
  dynamic language;
  List<String> urns;
  List<dynamic> groups;
  Fields fields;
  bool blocked;
  bool stopped;
  DateTime createdOn;
  DateTime modifiedOn;
  dynamic lastSeenOn;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    uuid: json["uuid"],
    name: json["name"],
    language: json["language"],
    urns: List<String>.from(json["urns"].map((x) => x)),
    groups: List<dynamic>.from(json["groups"].map((x) => x)),
    fields: Fields.fromJson(json["fields"]),
    blocked: json["blocked"],
    stopped: json["stopped"],
    createdOn: DateTime.parse(json["created_on"]),
    modifiedOn: DateTime.parse(json["modified_on"]),
    lastSeenOn: json["last_seen_on"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "language": language,
    "urns": List<dynamic>.from(urns.map((x) => x)),
    "groups": List<dynamic>.from(groups.map((x) => x)),
    "fields": fields.toJson(),
    "blocked": blocked,
    "stopped": stopped,
    "created_on": createdOn.toIso8601String(),
    "modified_on": modifiedOn.toIso8601String(),
    "last_seen_on": lastSeenOn,
  };
}

class Fields {
  Fields();

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
  );

  Map<String, dynamic> toJson() => {
  };
}
