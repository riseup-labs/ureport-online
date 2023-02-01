import 'package:get_storage/get_storage.dart';

class SPUtil {
  static String KEY_SUB_DOMAIN = "KEY_SUB_DOMAIN";

  static String KEY_AUTH_TOKEN = "KEY_AUTH_TOKEN";
  static String KEY_USER_ID = "KEY_USER_ID";
  static String KEY_USER_ROLE = "KEY_USER_ROLE";

  static String KEY_DARK_THEME = "KEY_DARK_THEME";
  static String PROGRAMKEY = "PROGRAM_KEY";
  static String OPINIONDATA = "DATA";
  static String CONTACT_URN = "CONTACT_URN";
  static String REGISTRATION_COMPLETE = "REGISTRATION_COMPLETE";
  static String PROGRAMCHANGE = "PROGRAMCHANGE";
  static String OPINION_LAST_UPDATE = "opinion_last_update";
  static String STORY_LAST_UPDATE = "story_last_update";

  static String DELETE5DAYS = "DELETE5DAYS";
  static String CONTACT_URN_INDIVIDUAL_CASE = "CONTACT_URN_INDIVIDUAL_CASE";
  static String FIRSTMESSAGE = "FIRSTMESSAGE";
  static String LAST_MESSAGE = "last_message";
  static String USER_ROLE = "user_role";
  static String SOUND = "sound";
  static String REG_CALLED = "reg_called";
  static String ABOUT_DATA = "about_data";
  static String ABOUT_TITLE = "about_title";
  static String STORY_NEXT = "story_next";
  static String STORY_COUNT = "story_count";

  setValue(String key, String value) async {
    GetStorage().write(key, value);
  }

  setInt(String key, int value) async {
    GetStorage().write(key, value);
  }

  deleteKey(String key) async {
    GetStorage().remove(key);
  }

  String getValue(String key) {
    var result = GetStorage().read(key);
    return result == null ? "" : GetStorage().read(key);
  }

  int getInt(String key) {
    if (GetStorage().hasData(key)) {
      return GetStorage().read(key);
    } else {
      return 0;
    }
  }

  String getValueNoNull(String key) {
    if (GetStorage().hasData(key)) {
      return GetStorage().read(key);
    } else {
      return "";
    }
  }
}
