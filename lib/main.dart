import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open/app_init.dart';
import 'package:flutter_open/utils/splash_loading.dart';
import 'package:flutter_open/utils/toast_utils.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: _onWillPop,
        child: FutureBuilder(
            future: AppInit.init(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return HomePage();
              } else {
                return Loading();
              }
            }),
      ),
    );
  }

  DateTime? _lastTapTime;

  Future<bool> _onWillPop() async {
    debugPrint("_lastTapTime=$_lastTapTime;;;now=${DateTime.now()}");
    if (_lastTapTime == null ||
        (DateTime.now().difference(_lastTapTime!)) > Duration(seconds: 2)) {
      _lastTapTime = DateTime.now();
      WgsvenToast.showTips("再按一次退出APP");
      return false;
    } else {
      WgsvenToast.showError("再按一次");
      return true;
    }
  }
}
