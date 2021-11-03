// To parse this JSON data, do
//
//     final responseRemoteConfigData = responseRemoteConfigDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ResponseRemoteConfigData responseRemoteConfigDataFromJson(String str) => ResponseRemoteConfigData.fromJson(json.decode(str));

String responseRemoteConfigDataToJson(ResponseRemoteConfigData data) => json.encode(data.toJson());

class ResponseRemoteConfigData {
  ResponseRemoteConfigData({
    required this.programs,
  });

  List<Program> programs;

  factory ResponseRemoteConfigData.fromJson(Map<String, dynamic> json) => ResponseRemoteConfigData(
    programs: List<Program>.from(json["programs"].map((x) => Program.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "programs": List<dynamic>.from(programs.map((x) => x.toJson())),
  };
}

class Program {
  Program({
    required this.status,
    required this.name,
    required this.storyApi,
    required this.opinionApi,
    required this.channelId,
    required this.channelHost,
    required this.storyShareUrl,
    required this.largeIcon,
    required this.smallIcon,
    required this.aboutUrl,
    required this.programBackgroundColor,
    required this.programTextColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.triggerKeywords,
  });

  bool status;
  String name;
  String storyApi;
  String opinionApi;
  String channelId;
  String channelHost;
  String storyShareUrl;
  String largeIcon;
  String smallIcon;
  String aboutUrl;
  String programBackgroundColor;
  String programTextColor;
  String primaryColor;
  List<String> secondaryColor;
  TriggerKeywords triggerKeywords;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
    status: json["status"],
    name: json["name"],
    storyApi: json["story_api"],
    opinionApi: json["opinion_api"],
    channelId: json["channel_id"],
    channelHost: json["channel_host"],
    storyShareUrl: json["story_share_url"],
    largeIcon: json["large_icon"],
    smallIcon: json["small_icon"],
    aboutUrl: json["about_url"],
    programBackgroundColor: json["program_background_color"],
    programTextColor: json["program_text_color"],
    primaryColor: json["primary_color"],
    secondaryColor: List<String>.from(json["secondary_color"].map((x) => x)),
    triggerKeywords: TriggerKeywords.fromJson(json["trigger_keywords"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "name": name,
    "story_api": storyApi,
    "opinion_api": opinionApi,
    "channel_id": channelId,
    "channel_host": channelHost,
    "story_share_url": storyShareUrl,
    "large_icon": largeIcon,
    "small_icon": smallIcon,
    "about_url": aboutUrl,
    "program_background_color": programBackgroundColor,
    "program_text_color": programTextColor,
    "primary_color": primaryColor,
    "secondary_color": List<dynamic>.from(secondaryColor.map((x) => x)),
    "trigger_keywords": triggerKeywords.toJson(),
  };
}

class TriggerKeywords {
  TriggerKeywords({
    required this.registrationFlow,
    required this.idleFlow,
  });

  String registrationFlow;
  String idleFlow;

  factory TriggerKeywords.fromJson(Map<String, dynamic> json) => TriggerKeywords(
    registrationFlow: json["registration_flow"],
    idleFlow: json["idle_flow"],
  );

  Map<String, dynamic> toJson() => {
    "registration_flow": registrationFlow,
    "idle_flow": idleFlow,
  };
}
