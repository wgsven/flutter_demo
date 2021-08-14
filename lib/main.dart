import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open/app_init.dart';
import 'package:flutter_open/utils/get_materialapp_widget.dart';
import 'package:flutter_open/utils/splash_loading.dart';
import 'package:flutter_open/utils/whole_will_pop.dart';

import 'main_page.dart';

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
    return GetMaterialAppWidget(
      child: WillPopScope(
        onWillPop: WholeWillPop.instance.onWillPop,
        child: FutureBuilder(
            future: AppInit.init(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return MainPage();
              } else {
                return SplashLoading();
              }
            }),
      ),
    );
  }
}

