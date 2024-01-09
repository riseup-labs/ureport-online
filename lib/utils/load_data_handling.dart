import 'package:intl/intl.dart';
import 'package:ureport_ecaro/locator/locator.dart';

import 'sp_utils.dart';

class LoadDataHandling {
  static bool checkStoryLoadAvailability() {
    var sp = locator<SPUtil>();
    String lastUpdate = sp.getValue(
        "${SPUtil.STORY_LAST_UPDATE}_${sp.getValue(SPUtil.PROGRAMKEY)}")!;

    if (lastUpdate == null) {
      return true;
    } else {
      DateTime lastDate = DateTime.parse(lastUpdate);
      DateTime currentDate = getCurrentDate();
      if (lastDate.isBefore(currentDate)) {
        return true;
      } else {
        return false;
      }
    }
  }

  static bool checkOpinionLoadAvailability() {
    var sp = locator<SPUtil>();
    String lastUpdate = sp.getValue(
        "${SPUtil.OPINION_LAST_UPDATE}_${sp.getValue(SPUtil.PROGRAMKEY)}")!;

    if (lastUpdate == null) {
      return true;
    } else {
      DateTime lastDate = DateTime.parse(lastUpdate);
      DateTime currentDate = getCurrentDate();
      if (lastDate.isBefore(currentDate)) {
        return true;
      } else {
        return false;
      }
    }
  }

  static DateTime getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    DateTime currentDate = DateTime.parse(formatted);
    return currentDate;
  }

  static storeStoryLastUpdate() {
    var sp = locator<SPUtil>();
    sp.setValue("${SPUtil.STORY_LAST_UPDATE}_${sp.getValue(SPUtil.PROGRAMKEY)}",
        getCurrentDate().toString());
  }

  static storeOpinionLastUpdate() {
    var sp = locator<SPUtil>();
    sp.setValue(
        "${SPUtil.OPINION_LAST_UPDATE}_${sp.getValue(SPUtil.PROGRAMKEY)}",
        getCurrentDate().toString());
  }
}
