import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void toPage(Widget page, bool opaque) {
  Get.to(() => page, opaque: opaque);
}

void toName(String page, dynamic arguments) {
  Get.toNamed(page, arguments: arguments);
}

void back() {
  Get.back();
}

dynamic arguments() {
  return Get.arguments;
}
