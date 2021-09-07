import 'package:flutter_open/http/http_manager.dart';
import 'package:flutter_open/http/url.dart';
import 'package:flutter_open/model/discovery/category_model.dart';
import 'package:flutter_open/utils/toast_utils.dart';
import 'package:flutter_open/viewmodel/base_change_notifier.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';

class CategoryViewModel extends BaseChangeNotifier {
  List<CategoryModel> itemList = [];

  void requestData() {
    HttpManager.getData(
        url: Url.categoryUrl,
        success: (result) {
          itemList = (result as List)
              .map((item) => CategoryModel.fromJson(item))
              .toList();
          viewState = ViewState.done;
        },
        fail: (e) {
          WgsvenToast.showError(e.toString());
          viewState = ViewState.error;
        },
        complete: () {
          notifyListeners();
        });
  }
}
