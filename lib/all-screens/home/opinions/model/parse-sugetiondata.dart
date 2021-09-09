// To parse this JSON data, do
//
//     final sugetiondata = sugetiondataFromJson(jsonString);

import 'dart:convert';



class Sugetiondata {
  Sugetiondata({
    required this.category,
    required this.title,
  });

  String category;
  List<dynamic> title;

}
