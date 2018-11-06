// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter_driver/driver_extension.dart';

// To use this test: "flutter drive --route '/smuggle-it' lib/route.dart"

void main() {
  enableFlutterDriverExtension(handler: handler);
}

DataHandler handler = (String message) async {
  if (message == 'route') {
    print('message = $message');
    print('routeName = ${ui.window.defaultRouteName}');
//    return ui.window.defaultRouteName;
    return '/smuggle-it';
  } else if (message == 'route22') {
    return message;
  }
};
