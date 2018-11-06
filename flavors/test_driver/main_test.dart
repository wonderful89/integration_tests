// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('flavors suite', () {
    FlutterDriver driver;

    setUpAll(() async {
      print('aa');
      driver = await FlutterDriver.connect();
    });

    test('check flavor', () async {
      final SerializableFinder flavorField = find.byValueKey('flavor');
      final String flavor = await driver.getText(flavorField);
      expect(flavor, 'paid');
    });

    tearDownAll(() async {
      driver?.close();
    });
  });
}

/// flutter driver -d  63614955-DDCD-4CC2-AC14-7FB3100E480E  --flavor=Free lib/main.dart (fail)
/// flutter driver -d  63614955-DDCD-4CC2-AC14-7FB3100E480E  --flavor=Paid lib/main.dart (success)

//--flavor (口味):Build a custom app flavor as defined by platform-specific build setup.
//Supports the use of product flavors in Android Gradle scripts.
//Supports the use of custom Xcode schemes.

/// 感觉就是个配置，还需要自己实现Native 方法，用处不大
