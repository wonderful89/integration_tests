// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    print('setUpAll');
  });

  tearDownAll(() async {
    driver?.close();
  });

  test('check that we are showing the performance overlay', () async {
    await driver.requestData('status'); // force a reassemble
    await driver.waitFor(find.byType('PerformanceOverlay'),
        timeout: Duration.zero);
  });
}

/// flutter driver -d XXX --profile  lib/commands_performance_overlay.dart // 貌似有问题， 没试验成功
