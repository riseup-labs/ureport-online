import 'package:get_storage/get_storage.dart';

class SPUtil {
  static String KEY_SUB_DOMAIN = "KEY_SUB_DOMAIN";

  static String KEY_AUTH_TOKEN = "KEY_AUTH_TOKEN";
  static String KEY_USER_ID = "KEY_USER_ID";
  static String KEY_USER_ROLE = "KEY_USER_ROLE";
  static String DELETE5DAYS = "DELETE5DAYS";

  static String KEY_DARK_THEME = "KEY_DARK_THEME";
  static String PROGRAMKEY = "PROGRAM_KEY";
  static String OPINIONDATA = "DATA";
  static String CONTACT_URN = "CONTACT_URN";
  static String CONTACT_URN_INDIVIDUAL_CASE = "CONTACT_URN_INDIVIDUAL_CASE";
  static String REGISTRATION_COMPLETE = "REGISTRATION_COMPLETE";
  static String PROGRAMCHANGE = "PROGRAMCHANGE";
  static String FIRSTMESSAGE = "FIRSTMESSAGE";


  setValue(String key, String value) async {
    GetStorage().write(key, value);
  }

  deleteKey(String key) async {
    GetStorage().remove(key);
  }

  String getValue(String key) {
    return GetStorage().read(key);
  }

}