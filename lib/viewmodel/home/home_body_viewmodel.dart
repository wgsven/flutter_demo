
import 'package:flutter_open/viewmodel/base_change_notifier.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';

class HomeBodyVm extends BaseChangeNotifier{
  ViewState _viewState = ViewState.loading;

  void refresh(){

  }
  void retry(){
    _viewState = ViewState.loading;
    notifyListeners();
    refresh();
  }
}