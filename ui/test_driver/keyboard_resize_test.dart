// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:integration_ui/keys.dart' as keys;
import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('end-to-end test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver?.close();
    });

    test('Ensure keyboard dismissal resizes the view to original size',
        () async {
      // 设置是否允许enterText 输入
      await driver.setTextEntryEmulation(enabled: false);
      final SerializableFinder heightText = find.byValueKey(keys.kHeightText);
      await driver.waitFor(heightText);

      // Measure the initial height.
      final String startHeight = await driver.getText(heightText);

      // Focus the text field to show the keyboard.
      final SerializableFinder defaultTextField =
          find.byValueKey(keys.kDefaultTextField);
      await driver.waitFor(defaultTextField);
      await driver.tap(defaultTextField);
//      await driver.enterText('aaaaa'); // 现在不允许输入，如果打开，则抛出异常
      await Future<void>.delayed(const Duration(seconds: 1));

      // Measure the height with keyboard displayed.
      final String heightWithKeyboardShown = await driver.getText(heightText);
      expect(double.parse(heightWithKeyboardShown) < double.parse(startHeight),
          isTrue);

      // Unfocus the text field to dismiss the keyboard.
      final SerializableFinder unfocusButton =
          find.byValueKey(keys.kUnfocusButton);
      await driver.waitFor(unfocusButton);
      await driver.tap(unfocusButton);
      await Future<void>.delayed(const Duration(seconds: 1));

      // Measure the final height.
      final String endHeight = await driver.getText(heightText);

      expect(endHeight, startHeight);
    });
  });
}

/// 继承测试的textFiled，不支持flutter run 点击。
/// 需要用flutter driver 跑起来
/// 使用StackFit.expand 撑起高度，这里会排除键盘的高度。（如何不排除？ resizeToAvoidBottomPadding: false）
