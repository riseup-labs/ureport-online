// To parse this JSON data, do
//
//     final responseRemoteConfigData = responseRemoteConfigDataFromJson(jsonString);

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
    required this.logo,
    required this.storyApi,
    required this.storyDetailsApi,
    required this.opinionApi,
    required this.channelId,
    required this.triggerKeywords,
  });

  bool status;
  String name;
  String logo;
  String storyApi;
  String storyDetailsApi;
  String opinionApi;
  String channelId;
  TriggerKeywords triggerKeywords;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
    status: json["status"],
    name: json["name"],
    logo: json["logo"],
    storyApi: json["story_api"],
    storyDetailsApi: json["story_details_api"],
    opinionApi: json["opinion_api"],
    channelId: json["channel_id"],
    triggerKeywords: TriggerKeywords.fromJson(json["trigger_keywords"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "name": name,
    "logo": logo,
    "story_api": storyApi,
    "story_details_api": storyDetailsApi,
    "opinion_api": opinionApi,
    "channel_id": channelId,
    "trigger_keywords": triggerKeywords.toJson(),
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
    required this.welcomeFlow,
    required this.recentFlow,
  });

  String registrationFlow;
  String welcomeFlow;
  String recentFlow;

  factory Ar.fromJson(Map<String, dynamic> json) => Ar(
    registrationFlow: json["registration_flow"],
    welcomeFlow: json["welcome_flow"],
    recentFlow: json["recent_flow"],
  );

  Map<String, dynamic> toJson() => {
    "registration_flow": registrationFlow,
    "welcome_flow": welcomeFlow,
    "recent_flow": recentFlow,
  };
}
