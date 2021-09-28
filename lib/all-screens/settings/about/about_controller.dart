import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';

import 'apout_repository.dart';
import 'model/response_about.dart';

class AboutController extends ConnectivityController{

  var _aboutService = locator<AboutRepository>();
  ResponseAbout? aboutData;

  var isLoading = false;
  setLoading(){
    isLoading = true;
    notifyListeners();
  }

  getAboutFromRemote(String url) async {
    setLoading();
    var apiresponsedata = await _aboutService.getAbout(url);
    if(apiresponsedata.httpCode==200){
      aboutData = apiresponsedata.data;
      notifyListeners();
      isLoading = false;
    }else{
      isLoading = false;
      notifyListeners();
    }
  }



}