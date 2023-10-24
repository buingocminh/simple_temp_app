import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_temp/services/log_service.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../common/dialogs/no_internet_dialog.dart';
import '../common/exceptions/refresh_exception.dart';
import '../configs/basic_config.dart';
import 'mock_service.dart';
import '../common/extensions/string_extension.dart';
enum Method {
  get,
  post,
  put,
  delete
}

_NoInternetHandler _apiNoInternetHandler = _NoInternetHandler();

class ApiService {
  
  /// Basic method to call api in app
  /// 
  /// [method] is api method type
  /// [path] is request url
  /// [header] is request header
  /// [data] is request data 
  /// ```dart
  /// ApiService.fetchApi(
  ///    method: Method.post, 
  ///    path: "your path", 
  ///    header: {
  ///      "header 1" : "data",
  ///     "header 2" : "data"
  ///   },
  ///   data: {
  ///     "data 1" : "data",
  ///     "data 2" : "data"
  ///   },
  /// );
  /// ```
  /// [mockAction] need to declare in [listAction] inside mock_service.dart file. 
  /// When have [mockAction] app will open a dialog for user to pick mock case (use for testing only, when we don't have api yet).
  /// 
  /// when request return with [statusCode] >= 400 or app have no Internet or api call timeout this will throw a exception. 
  /// try using "try-catch" to catch the exception and do your work
  ///```dart
  ///try {
  ///   ApiService.fetchApi(
  ///     method: Method.post, 
  ///     path: "your path", 
  ///     header: {
  ///       "header 1" : "data",
  ///       "header 2" : "data"
  ///     },
  ///     data: {
  ///       "data 1" : "data",
  ///       "data 2" : "data"
  ///     },
  ///   );
  /// } catch (e) {
  ///    //do your work
  ///  }
  /// ```
  static Future<http.Response> fetchApi({
    required Method method,
    required String path,
    required Map<String, dynamic> data, 
    Map<String, String>? header, 
    String? mockAction
  }) async {
    Completer<http.Response> completer = Completer<http.Response>();
    try {
      late final http.Response response;
      if(mockAction != null && navigatorKey.currentContext!= null) {
        final callback = await MockService().showMockPicker(mockAction, navigatorKey.currentContext!);
        response =  await callback;
      } else {
        switch (method){
          case Method.get:
            response = await _get(path, header);
            break;
          case Method.post:
            response = await _post(path, data, header);
            break;
          case Method.put:
            response = await _put(path, data, header);
            break;
          case Method.delete:
            response = await _delete(path, data, header);
            break;
        }
      }
      
      if(response.statusCode == 401) throw RefreshException();
      if(response.statusCode >= 400) {
        completer.completeError(jsonDecode(response.body)['title']);
      } else {
        completer.complete(response);
      }
      
      // return response;
      
    } on SocketException {
      _apiNoInternetHandler.showNoInternetDialog(
        cancelFunction: () async {
          completer.completeError( "noInternetAlertTitle".tr());
        },
        retryFunction: () async {
          try {
            var result = await fetchApi(method: method,path: path,data: data, header: header, mockAction: mockAction);
            completer.complete(result);
          } catch(e) {
            completer.completeError(e.toString());
          }
        }
      );
      Logger.log("should response error");
    } on RefreshException {
      //TODO add logic to refresh access token
      rethrow;
    } on TimeoutException {
      //TODO write logic here
      rethrow;
    }
    return await completer.future;
  }

  static final Map<String, String> _defaultHeader = {
    "content-type": "application/json",
    //TODO If need to add accesstoken, pleas add it here
    //"Authorization" : boxDataUser.get("accessToken", defaultValue: "")
  };

  static Future<http.Response> _get(String path, Map<String, String>? header) async {
    _defaultHeader.addAll(header ?? {});
      return await http.get(
        Uri.parse(path),
        headers: _defaultHeader,
      );
  }

  static Future<http.Response> _put(String path, Map<String, dynamic> data,
      Map<String, String>? header) async {
    _defaultHeader.addAll(header ?? {});
    return await http.put(Uri.parse(path),
        headers: _defaultHeader, body: jsonEncode(data));
  }

  static Future<http.Response> _post(String path, Map<String, dynamic> data,
      Map<String, String>? header) async {
    _defaultHeader.addAll(header ?? {});
    return await http.post(
      Uri.parse(path),
      headers: _defaultHeader,
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> _delete(String path, Map<String, dynamic> data,
      Map<String, String>? header) async {
    _defaultHeader.addAll(header ?? {});
    return await http.delete(Uri.parse(path),
        headers: _defaultHeader, body: jsonEncode(data));
  }
}

class _NoInternetHandler {
  bool _isDialogShowing = false;
  final List<Function> _retryQueue = [];
  final List<Function> _cancelQueue = [];


  void showNoInternetDialog({required Future Function() cancelFunction ,required Future Function() retryFunction}) {
    _retryQueue.add(retryFunction);
    _cancelQueue.add(cancelFunction);
    if(navigatorKey.currentContext == null) return;
    if(!_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: navigatorKey.currentContext!, 
        builder: (_) => const NoInternetDialog()
      ).then((value) {
        if(value ?? false) {
          for (var function in _retryQueue) {
            function.call();
          }
          _retryQueue.clear();
          _cancelQueue.clear();
          _isDialogShowing = false;
        } else {
          for (var function in _cancelQueue) {
            function.call();
          }
          _retryQueue.clear();
          _cancelQueue.clear();
          _isDialogShowing = false;
        }
      });
    }
  }

}
