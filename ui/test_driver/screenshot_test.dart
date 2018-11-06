// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:image/image.dart';

import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('FlutterDriver', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    var writeDataToFile = ({String fileName, Uint8List data}) {
      var tmpDir = testOutputsDirectory;
      var file = new File('$tmpDir/imagess/$fileName');
      file.createSync(recursive: true);
      file.writeAsBytes(data);
    };

    test('should take screenshot', () async {
      final SerializableFinder toggleBtn = find.byValueKey('toggle');

//      var colorDDD =  Color(0xff0201ff);
      // Cards use a magic background color that we look for in the screenshots.
      final Matcher cardsAreVisible = contains(0xff0201ff);
      await driver.waitFor(toggleBtn);

      bool cardsShouldBeVisible = false;
      var dataList = await driver.screenshot();
      Image imageBefore = decodePng(dataList);
      writeDataToFile(fileName: 't2.png', data: dataList);
      for (int i = 0; i < 10; i += 1) {
        await driver.tap(toggleBtn);
        cardsShouldBeVisible = !cardsShouldBeVisible;
        final Image imageAfter = decodePng(await driver.screenshot());

        if (cardsShouldBeVisible) {
          expect(imageBefore.data, isNot(cardsAreVisible));
          expect(imageAfter.data, cardsAreVisible);
        } else {
          expect(imageBefore.data, cardsAreVisible);
          expect(imageAfter.data, isNot(cardsAreVisible));
        }

        imageBefore = imageAfter;
      }
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}

///
/// 原理
///
/// 根据是否包含contains(0xff0201ff);数据内容，来判定image是否显示在当前的界面上。
/// （魔法数字是什么原理？）
///
///增加了截屏图片保存函数：writeDataToFile
