import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';

extension StringExtension on String {
  String tr() {
    return translate(this);
  }
}