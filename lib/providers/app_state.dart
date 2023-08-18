
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import '../configs/api_config.dart';
import '../configs/constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/log_service.dart';

class AppState extends ChangeNotifier {

  //variable
  UserModel currentUser = UserModel.empty();

  late final boxAppData = Hive.box(boxAppSettingName);

  //getter
  bool get isLogin => currentUser.accessToken.isNotEmpty;
  //setter

  //function

  ///Init app state should run in Main
  Future initData() async {
    String accessToken = (boxAppData.get("accessToken", defaultValue: "") as String);
    if(accessToken.isNotEmpty) {
      currentUser.accessToken =  accessToken;
      //TODO get User data from access token
      //in this Example I will reuse login function, because of mock issue i cannot show it here

      // login({});
      // notifyListeners();
    }
  }

  Future login(Map<String,dynamic> data) async {
    try {
      await Future.wait(
        [
          ApiService.fetchApi(
            method: Method.get, 
            path: "https://www.google.com/", 
            data: data,
          ).then((value) {
            print("complete 1");
          }),
          ApiService.fetchApi(
            method: Method.get, 
            path: "https://www.google.com/", 
            data: data,
          ).then((value) => print("complete 2")),
        ]
      );
       
      // final Response response = await ApiService.fetchApi(
      //   method: Method.get, 
      //   path: ApiConfig.login, 
      //   data: data,
      // );
      // final body =  jsonDecode(response.body);
      // currentUser = UserModel.fromJson(body);
      // boxAppData.put("accessToken", currentUser.accessToken);
      // notifyListeners();
      // Logger.log(currentUser);
    } catch(e) {
      Logger.log("dkahdhsaddkb");
      Logger.log(e);
      rethrow;
    }
  } 

}