import 'package:flutter/material.dart';

class MessageModelLocal {
  String? message;
  final String sender;
  String status;
  String quicktypest;
  String time;

  MessageModelLocal({
    required this.message,
    required this.sender,
    required this.status,
    required this.quicktypest,
    required this.time,
  });




  factory MessageModelLocal.fromJson(Map<String, dynamic> json) =>
      MessageModelLocal(
        message: json["message"],
        sender: json["sender"],
        status: json["status"],
        quicktypest: json["quicktypest"],
        time: json["time"],
      );
}