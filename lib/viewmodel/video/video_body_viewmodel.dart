import 'package:flutter_open/http/http_manager.dart';
import 'package:flutter_open/http/url.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/utils/toast_utils.dart';
import 'package:flutter_open/viewmodel/base_change_notifier.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';

class VideoBodyViewModel extends BaseChangeNotifier {
  List<Item> itemList = [];
  late int _videoId;

  loadVideoData(int id) {
    _videoId = id;
    HttpManager.getData(
        url: "${Url.videoRelatedUrl}$_videoId",
        success: (json) {
          Issue issue = Issue.fromJson(json);
          itemList = issue.itemList ?? [];
          viewState = ViewState.done;
        },
        fail: (e) {
          viewState = ViewState.error;
          WgsvenToast.showError(e.toString());
        },
        complete: () => notifyListeners());
  }

  retry() {
    viewState = ViewState.loading;
    notifyListeners();
    loadVideoData(_videoId);
  }
}
