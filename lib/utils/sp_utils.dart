import 'package:get_storage/get_storage.dart';

class SPUtil {
  static String KEY_SUB_DOMAIN = "KEY_SUB_DOMAIN";

  static String KEY_AUTH_TOKEN = "KEY_AUTH_TOKEN";
  static String KEY_USER_ID = "KEY_USER_ID";
  static String KEY_USER_ROLE = "KEY_USER_ROLE";

  static String KEY_DARK_THEME = "KEY_DARK_THEME";
  static String PROGRAMKEY = "PROGRAM_KEY";
  static String OPINIONDATA = "DATA";

  setValue(String key, String value) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    GetStorage().write(key, value);
  }

  deleteKey(String key) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    GetStorage().remove(key);
  }

  String getValue(String key) {
    return GetStorage().read(key);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // try {
    //   var value = prefs.getString(key);
    //   return value;
    // } catch (error) {
    //   return null;
    // }
  }
}