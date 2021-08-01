import 'package:flutter/material.dart';

class BaseChangeNotifier with ChangeNotifier {
  //是否销毁
  bool _dispose = false;

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }
}
