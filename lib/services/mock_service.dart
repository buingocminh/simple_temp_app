import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/dummy_data.dart';
import '../common/dialogs/moc_picker_dialog.dart';
import '../models/mock_case.dart';


class MockService {

  final List<MockCase> defaultCase = [
    MockCase(
      name:  "No internet",
      description: "App have no internet",
      callBack: Future<Response?>.sync(() {
        return Future.error(const SocketException("No Socket available"));
      })
    ),

    MockCase(
      name: "TimeOut", 
      description: "Api call time out", 
      callBack: Future<Response?>.sync(() async {
        await Future.delayed(const Duration(seconds: 5));
        return Future.error(TimeoutException("Time out"));
      })
    )
  ];

  late final List<MockCase> userLogin = [
    ...defaultCase,
    MockCase(
      name: "Success", 
      description: "login success", 
      callBack: Future<Response>.sync(() {
        return Response(jsonEncode(userData), 200);
      })
    )
  ];

  late final Map<String,List<MockCase>> listAction = {
    "userLogin" : userLogin
  };

  Future<Future?> showMockPicker(String action, BuildContext context) async {
    final listCase = listAction[action] ?? [];
    return await showDialog<Future>(
      context: context,
      barrierDismissible: false,
      builder: (_) => MockPickerDialog(listCase,action)
    ) ?? listCase.first.callBack;
  }
}