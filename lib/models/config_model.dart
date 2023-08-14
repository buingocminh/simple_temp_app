import './navigation_observer_model.dart';

class Config {
  String appName =  "TempApp";
  late CustomRouteObserver appObserver;

  //TODO base contructor of Config class add needed variables 
  Config();

  Config copyWith(Map<String,dynamic> data) {
    return Config();
  }

}