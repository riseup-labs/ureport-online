// To parse this JSON data, do
//
//     final responseStartflow = responseStartflowFromJson(jsonString);

import 'dart:convert';

ResponseStartflow responseStartflowFromJson(String str) => ResponseStartflow.fromJson(json.decode(str));

String responseStartflowToJson(ResponseStartflow data) => json.encode(data.toJson());

class ResponseStartflow {
  ResponseStartflow({
    required this.id,
    required this.uuid,
    required this.flow,
    required this.status,
    required this.groups,
    required this.contacts,
    required this.restartParticipants,
    required this.excludeActive,
    this.extra,
    this.params,
    required this.createdOn,
    required this.modifiedOn,
  });

  int id;
  String uuid;
  Flow flow;
  String status;
  List<dynamic> groups;
  List<dynamic> contacts;
  bool restartParticipants;
  bool excludeActive;
  dynamic extra;
  dynamic params;
  DateTime createdOn;
  DateTime modifiedOn;

  factory ResponseStartflow.fromJson(Map<String, dynamic> json) => ResponseStartflow(
    id: json["id"],
    uuid: json["uuid"],
    flow: Flow.fromJson(json["flow"]),
    status: json["status"],
    groups: List<dynamic>.from(json["groups"].map((x) => x)),
    contacts: List<dynamic>.from(json["contacts"].map((x) => x)),
    restartParticipants: json["restart_participants"],
    excludeActive: json["exclude_active"],
    extra: json["extra"],
    params: json["params"],
    createdOn: DateTime.parse(json["created_on"]),
    modifiedOn: DateTime.parse(json["modified_on"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "flow": flow.toJson(),
    "status": status,
    "groups": List<dynamic>.from(groups.map((x) => x)),
    "contacts": List<dynamic>.from(contacts.map((x) => x)),
    "restart_participants": restartParticipants,
    "exclude_active": excludeActive,
    "extra": extra,
    "params": params,
    "created_on": createdOn.toIso8601String(),
    "modified_on": modifiedOn.toIso8601String(),
  };
}

class Flow {
  Flow({
    required this.uuid,
    required this.name,
  });

  String uuid;
  String name;

  factory Flow.fromJson(Map<String, dynamic> json) => Flow(
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
  };
}
