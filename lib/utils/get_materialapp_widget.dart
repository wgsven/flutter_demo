import 'package:flutter/material.dart';
import 'package:flutter_open/page/video/video_detail_page.dart';
import 'package:get/get.dart';

const ROUTE_HOME = "/";
const ROUTE_VIDEO_DETAIL = "/detail";

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
      initialRoute: ROUTE_HOME,
      getPages: [
        GetPage(name: ROUTE_HOME, page: () => widget.child),
        GetPage(name: ROUTE_VIDEO_DETAIL, page: () => VideoDetailPage())
      ],
    );
  }
}
