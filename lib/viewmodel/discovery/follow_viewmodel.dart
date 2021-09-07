import 'package:flutter_open/http/url.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/viewmodel/base_list_viewmodel.dart';

class FollowViewModel extends BaseListViewModel<Item, Issue> {
  @override
  Issue getModel(Map<String, dynamic> json) {
    return Issue.fromJson(json);
  }

  @override
  String getUrl() {
    return Url.followUrl;
  }
}
