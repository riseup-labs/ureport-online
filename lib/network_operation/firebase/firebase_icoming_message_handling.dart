import 'package:flutter/material.dart';

class MessageModel {
  String? message;
  final String sender;
  String status;
  List<dynamic> quicktypest;
  String time;


  MessageModel({
    required this.message,
    required this.sender,
    required this.status,
    required this.quicktypest,
    required this.time,
  });




  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      MessageModel(
        message: json["message"],
        sender: json["sender"],
        status: json["status"],
        quicktypest: List<dynamic>.from(json["quicktypest"].map((x) => x)),
        time: json["time"],
      );
}