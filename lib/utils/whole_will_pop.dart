import 'package:flutter_open/utils/toast_utils.dart';

class WholeWillPop {
  WholeWillPop._();
  static  WholeWillPop? _instance;
  static WholeWillPop get instance =>_getInstance();

  static WholeWillPop _getInstance(){
    if(_instance == null){
       _instance = WholeWillPop._();
    }
    return _instance!;
  }

  DateTime? _lastTapTime;

  Future<bool> onWillPop() async {
    if (_lastTapTime == null || (DateTime.now().difference(_lastTapTime!)) > Duration(seconds: 2)) {
      _lastTapTime = DateTime.now();
      WgsvenToast.showTips("再按一次退出APP");
      return false;
    } else {
      return true;
    }
  }
}
