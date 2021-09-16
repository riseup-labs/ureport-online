
import 'package:audioplayers/audioplayers.dart';

class ClickSound {

  static final player = AudioCache();

  static buttonClickYes(){

    player.play('audio/button_click_yes.mp3');
  }

  static buttonClickNo(){
    player.play('audio/button_click_no.mp3');
  }

  static noInternetAlert(){
    player.play('audio/no_internet_alert.mp3');
  }

  static receiveMessage(){
    player.play('audio/receive_message_sound.mp3');
  }

  static sendMessage(){
    player.play('audio/send_message_sound.mp3');
  }

  static settingsChanged(){
    player.play('audio/setting_button_change.mp3');
  }

  static syncComplete(){
    player.play('audio/sync_complete.mp3');
  }



}
