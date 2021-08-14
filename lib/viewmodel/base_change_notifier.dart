import 'package:flutter/material.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';

class BaseChangeNotifier with ChangeNotifier {
  //是否销毁
  bool _dispose = false;
  ViewState viewState = ViewState.loading;

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
