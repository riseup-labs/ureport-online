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
    required this.storyShareUrl,
    required this.largeIcon,
    required this.smallIcon,
    required this.individualCaseManagement,
    required this.primaryColor,
    required this.secondaryColor,
    required this.defaultTriggerActions,
    required this.icmsTriggerActions,
    required this.triggerKeywords,
    required this.logo,
  });

  bool status;
  String name;
  String storyApi;
  String opinionApi;
  String channelId;
  String storyShareUrl;
  String largeIcon;
  String smallIcon;
  bool individualCaseManagement;
  String primaryColor;
  List<String> secondaryColor;
  List<String> defaultTriggerActions;
  List<String> icmsTriggerActions;
  TriggerKeywords triggerKeywords;
  String logo;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
    status: json["status"],
    name: json["name"],
    storyApi: json["story_api"],
    opinionApi: json["opinion_api"],
    channelId: json["channel_id"],
    storyShareUrl: json["story_share_url"],
    largeIcon: json["large_icon"],
    smallIcon: json["small_icon"],
    individualCaseManagement: json["individual_case_management"],
    primaryColor: json["primary_color"],
    secondaryColor: List<String>.from(json["secondary_color"].map((x) => x)),
    defaultTriggerActions: List<String>.from(json["default_trigger_actions"].map((x) => x)),
    icmsTriggerActions: List<String>.from(json["icms_trigger_actions"].map((x) => x)),
    triggerKeywords: TriggerKeywords.fromJson(json["trigger_keywords"]),
    logo: json["logo"] == null ? null : json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "name": name,
    "story_api": storyApi,
    "opinion_api": opinionApi,
    "channel_id": channelId,
    "story_share_url": storyShareUrl,
    "large_icon": largeIcon,
    "small_icon": smallIcon,
    "individual_case_management": individualCaseManagement,
    "primary_color": primaryColor,
    "secondary_color": List<dynamic>.from(secondaryColor.map((x) => x)),
    "default_trigger_actions": List<dynamic>.from(defaultTriggerActions.map((x) => x)),
    "icms_trigger_actions": List<dynamic>.from(icmsTriggerActions.map((x) => x)),
    "trigger_keywords": triggerKeywords.toJson(),
    "logo": logo == null ? null : logo,
  };
}

class TriggerKeywords {
  TriggerKeywords({
    required this.en,
    required this.ar,
    required this.zh,
    required this.fr,
    required this.ru,
    required this.es,
  });

  Ar en;
  Ar ar;
  Ar zh;
  Ar fr;
  Ar ru;
  Ar es;

  factory TriggerKeywords.fromJson(Map<String, dynamic> json) => TriggerKeywords(
    en: Ar.fromJson(json["en"]),
    ar: Ar.fromJson(json["ar"]),
    zh: Ar.fromJson(json["zh"]),
    fr: Ar.fromJson(json["fr"]),
    ru: Ar.fromJson(json["ru"]),
    es: Ar.fromJson(json["es"]),
  );

  Map<String, dynamic> toJson() => {
    "en": en.toJson(),
    "ar": ar.toJson(),
    "zh": zh.toJson(),
    "fr": fr.toJson(),
    "ru": ru.toJson(),
    "es": es.toJson(),
  };
}

class Ar {
  Ar({
    required this.registrationFlow,
    required this.recentFlow,
  });

  String registrationFlow;
  String recentFlow;

  factory Ar.fromJson(Map<String, dynamic> json) => Ar(
    registrationFlow: json["registration_flow"],
    recentFlow: json["recent_flow"],
  );

  Map<String, dynamic> toJson() => {
    "registration_flow": registrationFlow,
    "recent_flow": recentFlow,
  };
}
