import 'package:flutter/cupertino.dart';
import 'package:flutter_open/viewmodel/base_change_notifier.dart';

class TabNavigationVm extends BaseChangeNotifier {
  int currentIndex = 0;

  changeBottomTabIndex(int index) {
    debugPrint("index=$index========currentIndex=$currentIndex");
    this.currentIndex = index;
    notifyListeners();
  }
}
