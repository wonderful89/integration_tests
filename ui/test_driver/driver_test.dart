// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('FlutterDriver', () {
    print('bb = bbb');
    final SerializableFinder presentText = find.text('present');
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    // waitFor- 等待存在
    test('1. waitFor should find text "present"', () async {
      await driver.waitFor(presentText);
    });

    // waitForAbsent- 不存在 （失败)
    // 下面的例子是1s内没有等到presentText消失。
    test(
        '2. waitForAbsent should time out waiting for text "present" to disappear',
        () async {
      try {
//        await driver.tap(find.byValueKey('togglePresent')); // 加上这句，下面会抛出异常
        await driver.waitForAbsent(presentText,
            timeout: const Duration(seconds: 1));
        print('111'); // 没有正常执行到这里
        fail('expected DriverError');
      } on DriverError catch (error) {
        print('222');
        expect(
            error.message, contains('Timeout while executing waitForAbsent'));
      }
    });

    // waitForAbsent- 等待从存在到不存在 （成功)
    test('3. waitForAbsent should resolve when text "present" disappears',
        () async {
      // Begin waiting for it to disappear
      final Completer<void> whenWaitForAbsentResolves = Completer<void>();
      driver
          .waitForAbsent(presentText, timeout: const Duration(seconds: 3))
          .then(
            whenWaitForAbsentResolves.complete,
            onError: whenWaitForAbsentResolves.completeError,
          );

      // Wait 1 second then make it disappear
      await Future<void>.delayed(const Duration(seconds: 1));
      await driver.tap(find.byValueKey('togglePresent'));

      // Ensure waitForAbsent resolves
      await whenWaitForAbsentResolves.future;
    });

    test('4. waitFor times out waiting for "present" to reappear', () async {
      try {
        await driver.waitFor(presentText, timeout: const Duration(seconds: 1));
        fail('expected DriverError');
      } on DriverError catch (error) {
        expect(error.message, contains('Timeout while executing waitFor'));
      }
    });

    test('5. waitFor should resolve when text "present" reappears', () async {
      // Begin waiting for it to reappear
      final Completer<void> whenWaitForResolves = Completer<void>();
      driver.waitFor(presentText).then(
            whenWaitForResolves.complete,
            onError: whenWaitForResolves.completeError,
          );

      // Wait 1 second then make it appear
      await Future<void>.delayed(const Duration(seconds: 1));
      await driver.tap(find.byValueKey('togglePresent'));

      // Ensure waitFor resolves
      await whenWaitForResolves.future;
    });

    test(
        '6. waitForAbsent resolves immediately when the element does not exist',
        () async {
      await driver.waitForAbsent(find.text('that does not exist'),
          timeout: new Duration(seconds: 3));
    });

    // 这个例子说明点击以后，立马生效
    test('7. uses hit test to determine tappable elements', () async {
      final SerializableFinder a = find.byValueKey('a');
      final SerializableFinder menu = find.byType('_DropdownMenu<Letter>');

      // Dropdown is closed
      await driver.waitForAbsent(menu);

      // Open dropdown
      await driver.tap(a);
//      await driver.tap(a);
      await driver.waitFor(menu);

      // Close it again
      await driver.tap(a);
      await driver.waitForAbsent(menu);
    });

    // 输入框中加入文本
    test('8. enters text in a text field', () async {
      final SerializableFinder textField = find.byValueKey('enter-text-field');
      await driver.tap(textField);
      await driver.enterText('Hello!');
      await driver.waitFor(find.text('Hello!'));
      await driver.enterText('World!');
      await driver.waitFor(find.text('World!'));
    });
  });
}

/// fail('expected DriverError'); 函数直接抛出异常。 默认超时时间 5s
/// 注意这里：Completer<void>(); 的用法（两种结果 complete/completeError) ,下面调用whenWaitForResolves.future
///
///
