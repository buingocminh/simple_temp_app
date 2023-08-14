import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../common/extensions/map_extension.dart';


enum CustomActionName {
  click,
  select_content,
  log
}

class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {

  final BuildContext context;
  static String screenName = "";

  CustomRouteObserver({required this.context});

  Future<void> _sendScreenView(PageRoute<dynamic> route) async {
    String? name = route.settings.name;
    if(name == null) return;
    FirebaseAnalytics.instance.setCurrentScreen(screenName: name);
    screenName = name;
  }

  void logCustomAction({required CustomActionName action, required Map<String,dynamic> param}) {
    param = param.map<String,String>((key, value) => MapEntry(key, value.toString()));
    param["screen_name"] = screenName;
    FirebaseAnalytics.instance.logEvent(
      name: action.name,
      parameters: param.formatParam()
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}