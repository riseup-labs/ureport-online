import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ureport_ecaro/firebase-remote-config/response-remote-config-data.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class RemoteConfigData {
  static getProgramList() {
    List<String> list = [];
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      list.add(element.name);
    });
    return list;
  }

  static List<DropdownMenuItem<String>> getProgramListForProgramChooser() {
    List<DropdownMenuItem<String>> list = [];
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      print(element.name);
      if (element.status == true) {
        list.add(DropdownMenuItem(
          value: element.name,
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: element.smallIcon,
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(element.name)
            ],
          ),
        ));
      }
    });
    return list;
  }

  static getStoryUrl(String program) {
    String url = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        url = element.storyApi;
      }
    });
    return url;
  }

  static getStoryShareUrl() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String url = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        url = element.storyShareUrl;
      }
    });
    return url;
  }

  static getOpinionShareUrl() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String url = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        url = element.opinionShareUrl;
      }
    });
    return url;
  }

  static getLargeIcon() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String url = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        url = element.largeIcon;
      }
    });
    return url;
  }

  static getSmallIcon() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String url = "";
    ResponseRemoteConfigData data = getAllData();
    print(data);
    data.programs.forEach((element) {
      if (element.name == program) {
        url = element.smallIcon;
      }
    });
    return url;
  }

  static getOpinionUrl(String program) {
    String url = "";
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        url = element.opinionApi;
      }
    });
    return url;
  }

  static getAboutUrl(String program) {
    String url = "";
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        url = element.aboutUrl;
      }
    });
    return url;
  }

  static getSecondaryColorList() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);
    List<Color> list = [];
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        element.secondaryColor.forEach((value) {
          list.add(HexColor(value));
        });
      }
    });

    return list;
  }

  static getPrimaryColor() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);
    Color color = Color(0);
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        color = HexColor(element.primaryColor);
      }
    });

    return color;
  }

  static getBackgroundColor() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);
    Color color = Color(0);
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        color = HexColor(element.programBackgroundColor);
      }
    });

    return color;
  }

  static getWebBackgroundColor() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);
    String color = "";
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        color = element.programBackgroundColor;
      }
    });

    return color;
  }

  static getWebTextColor() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);
    String color = "";
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        color = element.programTextColor;
      }
    });

    return color;
  }

  static getTextColor() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);
    Color color = Color(0);
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      if (element.name == program) {
        color = HexColor(element.programTextColor);
      }
    });

    return color;
  }

  static getDefaultActionVisibility() {
    return false;
  }

  static getIndividualCaseManagementVisibility() {
    return false;
  }

  static getDefaultAction() {
    List<String> list = [];
    return list;
  }

  static getOneToOneAction() {
    List<String> list = [];
    return list;
  }

  static getChannelId() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String channelId = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        channelId = element.channelId;
      }
    });
    return channelId;
  }

  static getRegistrationFlowKeyword() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String keyword = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        keyword = element.triggerKeywords.registrationFlow;
      }
    });
    return keyword;
  }

  static getIdleFlowKeyword() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String keyword = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        keyword = element.triggerKeywords.idleFlow;
      }
    });
    return keyword;
  }

  static getChannelHost() {
    var sp = locator<SPUtil>();
    String program = sp.getValue(SPUtil.PROGRAMKEY);

    String channelHost = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if (element.name == program) {
        channelHost = element.channelHost;
      }
    });
    return channelHost;
  }

  static getAllData() {
    var sp = locator<SPUtil>();
    Map<String, dynamic> data =
        jsonDecode(sp.getValue(SPConstant.ALL_PROGRAMS));
    var values = ResponseRemoteConfigData.fromJson(data);
    return values;
  }
}
