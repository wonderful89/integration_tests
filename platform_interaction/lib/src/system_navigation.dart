// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/services.dart';
import 'test_step.dart';

Future<TestStepResult> systemNavigatorPop() {
  const BasicMessageChannel<String> channel = BasicMessageChannel<String>(
    'navigation-test',
    StringCodec(),
  );

  // 创建Completer<TestStepResult>();等待结果
  final Completer<TestStepResult> completer = Completer<TestStepResult>();

  print('channel.setMessageHandler');
  channel.setMessageHandler((String message) async {
    print('in channel handle : $message');
    completer.complete(
        const TestStepResult('System navigation pop', '', TestStatus.ok));
    return '';
  });
  SystemNavigator.pop(); // 这一句是调用native的pop函数
  return completer.future;
}

/// SystemNavigator.pop(); 为什么没有push函数。这个例子里面pop只是发送了一条消息，也没有处理。
///
/// 要调用native函数，需要依赖于插件中native或者直接在App中运行native代码。
