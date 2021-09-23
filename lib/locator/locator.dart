import 'package:get_it/get_it.dart';
import 'package:ureport_ecaro/all-screens/home/chat/model/navigator-srvice.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_repository.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-repository.dart';
import 'package:ureport_ecaro/all-screens/settings/apout_repository.dart';
import 'package:ureport_ecaro/network_operation/http_service.dart';
import 'package:ureport_ecaro/network_operation/rapidpro_service.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

GetIt locator= GetIt.instance;

Future<void> setupLocator()async{

  locator.registerLazySingleton<SPUtil>(() => SPUtil());
  locator.registerLazySingleton<HttpService>(() => HttpService());
  locator.registerLazySingleton<RapidProService>(() => RapidProService());
  locator.registerLazySingleton<OpinionRepository>(() => OpinionRepository());
  locator.registerLazySingleton<StroyRipository>(() => StroyRipository());
  locator.registerLazySingleton<AboutRepository>(() => AboutRepository());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());

}