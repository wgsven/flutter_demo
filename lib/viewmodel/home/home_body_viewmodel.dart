import 'package:flutter_open/http/url.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/model/issue_model.dart';
import 'package:flutter_open/viewmodel/base_list_viewmodel.dart';

class HomeBodyVm extends BaseListViewModel<Item, IssueEntity> {
  List<Item>? banners = [];

  @override
  void getData(List<Item>? list) {
    banners = list;
    itemList.clear();
    //banner占位
    itemList.add(Item());
  }

  @override
  IssueEntity getModel(Map<String, dynamic> json) => IssueEntity.fromJson(json);

  @override
  String getUrl() => Url.feedUrl;

  @override
  void removeUselessData(List<Item>? list) {
    list?.removeWhere((element) => element.type == "banner2");
  }
}
