import 'package:audioplayers/audioplayers.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class ClickSound {
  static soundClick() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_click.mp3'));
    }
  }

  static soundClose() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_close.mp3'));
    }
  }

  static soundDropdown() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_dropdown.wav'));
    }
  }

  static soundMsgReceived() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_msg_received.mp3'));
    }
  }

  static soundMsgSend() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_msg_send.mp3'));
    }
  }

  static soundTyping() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_msg_typing.mp3'));
    }
  }

  static soundShare() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_share.mp3'));
    }
  }

  static soundTap() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/v2_click.mp3'));
    }
  }

  static soundNoInternet() {
    final player = AudioPlayer();
    var sp = locator<SPUtil>();
    String? status = sp.getValue(SPUtil.SOUND);
    if (status == "true") {
      player.play(AssetSource('audio/no_internet_alert.mp3'));
    }
  }
}
