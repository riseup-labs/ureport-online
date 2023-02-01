import 'package:audioplayers/audioplayers.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class ClickSound {
  static soundClick() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_click.mp3');
    }
  }

  static soundClose() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_close.mp3');
    }
  }

  static soundDropdown() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_dropdown.wav');
    }
  }

  static soundMsgReceived() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_msg_received.mp3');
    }
  }

  static soundMsgSend() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_msg_send.mp3');
    }
  }

  static soundTyping() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_msg_typing.mp3');
    }
  }

  static soundShare() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_share.mp3');
    }
  }

  static soundTap() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/v2_click.mp3');
    }
  }

  static soundNoInternet() {
    final player = AudioCache();
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.load('audio/no_internet_alert.mp3');
    }
  }
}
