import 'package:flutter/material.dart';

appbar(String title, {bool showBack = true, List<Widget>? actions,PreferredSizeWidget? bottoms}) {
  return AppBar(
    brightness: Brightness.light,
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    leading: showBack ? BackButton(color: Colors.black) : null,
    actions: actions,
    title: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottom: bottoms,
  );
}
