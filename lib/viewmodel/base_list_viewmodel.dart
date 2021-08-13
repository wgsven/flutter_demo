import 'package:flutter_open/http/http_manager.dart';
import 'package:flutter_open/model/paging_model.dart';
import 'package:flutter_open/utils/toast_utils.dart';
import 'package:flutter_open/viewmodel/base_change_notifier.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListViewModel<T, M extends PagingModel<T>>
    extends BaseChangeNotifier {
  List<T> itemList = [];
  String? nextPageUrl;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  String getUrl();

  M getModel(Map<String, dynamic> json);

  void removeUselessData(List<T>? list) {}

  void getData(List<T>? list);

  void doExtraAfterRefresh() {}

  //上拉加载更多请求地址
  String? getNextUrl(M model) {
    return model.nextPageUrl;
  }

  void refresh() {
    HttpManager.getData(
        url: getUrl(),
        success: (json) {
          M model = getModel(json);
          // IssueEntity issueEntity = IssueEntity.fromJson(json);
          // debugPrint("issueEntity=$issueEntity");
          removeUselessData(model.itemList);
          // banners = issueEntity.issueList?[0].itemList;
          // debugPrint("banners=$banners");
          // banners?.removeWhere((element) => element.type == "banner2");
          // debugPrint("banners2=$banners");
          getData(model.itemList);
          viewState = ViewState.done;

          //下一页数据
          nextPageUrl = getNextUrl(model);
          refreshController.refreshCompleted();
          refreshController.footerMode?.value = LoadStatus.canLoading;
          doExtraAfterRefresh();
        },
        fail: (e) {
          viewState = ViewState.error;
          refreshController.refreshFailed();
          WgsvenToast.showError(e.toString());
        },
        complete: () => notifyListeners());
  }

  Future<void> loadMore() async {
    if (nextPageUrl == null) {
      refreshController.loadNoData();
      return;
    }
    HttpManager.getData(
        url: nextPageUrl!,
        success: (json) {
          M model = getModel(json);
          removeUselessData(model.itemList);
          if (model.itemList != null) {
            itemList.addAll(model.itemList!);
          }
          nextPageUrl = getNextUrl(model);
          refreshController.refreshCompleted();
          notifyListeners();
        },
        fail: (e) {
          viewState = ViewState.error;
          refreshController.refreshFailed();
        });
  }

  void retry() {
    viewState = ViewState.loading;
    notifyListeners();
    refresh();
  }
}
