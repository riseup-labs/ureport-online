
import 'package:audioplayers/audioplayers.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class ClickSound {

  static final player = AudioCache();

  static buttonClickYes(){
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if(status == null || status == "true"){
      player.play('audio/button_click_yes.mp3');
    }
  }

  static buttonClickNo(){
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if(status == null || status == "true"){
      player.play('audio/button_click_no.mp3');
    }
  }

  static noInternetAlert(){
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if(status == null || status == "true"){
      player.play('audio/no_internet_alert.mp3');
    }
  }

  static receiveMessage(){
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if(status == null || status == "true"){
      player.play('audio/receive_message_sound.mp3');
    }
  }

  static sendMessage(){
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if(status == null || status == "true"){
      player.play('audio/send_message_sound.mp3');
    }
  }

  static settingsChanged(){
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if(status == null || status == "true"){
      player.play('audio/setting_button_change.mp3');
    }
  }

  static syncComplete(){
    var sp = locator<SPUtil>();
    String status = sp.getValue(SPUtil.SOUND);
    if(status == null || status == "true"){
      player.play('audio/sync_complete.mp3');
    }
  }


}
