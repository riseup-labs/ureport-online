import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'apout_repository.dart';
import 'model/response_about.dart';

class AboutController extends ConnectivityController{

  var _aboutService = locator<AboutRepository>();
  ResponseAbout? aboutData;
  String data = "";
  String title = "";
  var sp = locator<SPUtil>();

  var isLoading = false;
  var isRefreshing = false;
  setLoading(){
    isLoading = true;
    notifyListeners();
  }
  setRefreshing(){
    isRefreshing = true;
    notifyListeners();
  }

  getAboutFromRemote(String url) async {
    setLoading();
    var apiresponsedata = await _aboutService.getAbout(url);
    if(apiresponsedata.httpCode==200){
      aboutData = apiresponsedata.data;
      data = aboutData!.results[0].content;
      title = aboutData!.results[0].title;
      sp.setValue("${SPUtil.ABOUT_DATA}_${sp.getValue(SPUtil.PROGRAMKEY)}", aboutData!.results[0].content);
      sp.setValue("${SPUtil.ABOUT_TITLE}_${sp.getValue(SPUtil.PROGRAMKEY)}", aboutData!.results[0].title);
      notifyListeners();
      isLoading = false;
    }else{
      isLoading = false;
      notifyListeners();
    }
  }

  refreshAboutFromRemote(String url) async {
    setRefreshing();
    var apiresponsedata = await _aboutService.getAbout(url);
    if(apiresponsedata.httpCode==200){
      aboutData = apiresponsedata.data;
      data = aboutData!.results[0].content;
      title = aboutData!.results[0].title;
      sp.setValue("${SPUtil.ABOUT_DATA}_${sp.getValue(SPUtil.PROGRAMKEY)}", aboutData!.results[0].content);
      sp.setValue("${SPUtil.ABOUT_TITLE}_${sp.getValue(SPUtil.PROGRAMKEY)}", aboutData!.results[0].title);
      notifyListeners();
      isLoading = false;
      isRefreshing = false;
    }else{
      isLoading = false;
      isRefreshing = false;
      notifyListeners();
    }
  }



}