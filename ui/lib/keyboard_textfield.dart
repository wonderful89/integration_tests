// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'keys.dart' as keys;

void main() {
  enableFlutterDriverExtension();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keyboard & TextField',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _controller = ScrollController();
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        offset = _controller.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.only(top: 20.0),
            child: Text(
              '$offset',
              key: const ValueKey<String>(keys.kOffsetText),
            ),
          ),
          new Expanded(
            child: ListView(
              key: const ValueKey<String>(keys.kListView),
              controller: _controller,
              children: <Widget>[
                Container(
                  color: Colors.red,
//                  width: MediaQuery.of(context).size.width,
//                  height: MediaQuery.of(context).size.height,
                ),
                new TextField(
                  key: ValueKey<String>(keys.kDefaultTextField),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 这里其实使用ListView 里面自定义controller， 来实现键盘底部跟随输入的效果。
/// MediaQuery.of(context).size : 表示当前上下文的size, 而只要是全屏的时候才表示屏幕的size。（排除键盘的）
/// 中间差了一个offset 那个Container的高度
