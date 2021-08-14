

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetMaterialAppWidget extends StatefulWidget {
  late final Widget child;

  GetMaterialAppWidget({Key? key, required this.child}) : super(key: key);

  @override
  _GetMaterialAppWidgetState createState() => _GetMaterialAppWidgetState();
}

class _GetMaterialAppWidgetState extends State<GetMaterialAppWidget> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: "flutter_open",
    //   initialRoute: "/",
    //   routes: {"/": (context) => widget.child},
    // );
    // return GetMaterialApp(home: widget.child,);
    return GetMaterialApp(
      title: "flutter_open",
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page:()=> widget.child)
      ],
    );
  }
}
