import 'package:flutter/material.dart';

class MessageModel {
  String message;
  final String sender;
  String status;
  MessageModel({
    required this.message,
    required this.sender,
    required this.status,
  });
}