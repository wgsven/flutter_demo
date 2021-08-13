import 'package:flutter/cupertino.dart';
import 'package:flutter_open/http/http_manager.dart';
import 'package:flutter_open/http/url.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/model/issue_model.dart';
import 'package:flutter_open/utils/toast_utils.dart';
import 'package:flutter_open/viewmodel/base_change_notifier.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';

class HomeBodyVm extends BaseChangeNotifier {
  List<Item>? banners = [];

  void refresh() {
    HttpManager.getData(
        url: Url.feedUrl,
        success: (json) {
          debugPrint("json=$json");
          IssueEntity issueEntity = IssueEntity.fromJson(json);
          debugPrint("issueEntity=$issueEntity");
          banners = issueEntity.issueList?[0].itemList;
          debugPrint("banners=$banners");
          banners?.removeWhere((element) => element.type == "banner2");
          debugPrint("banners2=$banners");
          viewState = ViewState.done;
        },
        fail: (e) {
          viewState = ViewState.error;
          WgsvenToast.showError(e.toString());
        },
        complete: () => notifyListeners());
  }

  void retry() {
    viewState = ViewState.loading;
    notifyListeners();
    refresh();
  }
}
