import 'package:flutter_open/http/url.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/viewmodel/base_list_viewmodel.dart';

///https://baobab.kaiyanapp.com/api/v4/categories/videoList?id=14&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=Android
class CategoryDetailViewModel extends BaseListViewModel<Item, Issue> {
  // 区分点击的那个分类，必须传
  final int categoryId;

  CategoryDetailViewModel(this.categoryId);

  @override
  Issue getModel(Map<String, dynamic> json) => Issue.fromJson(json);

  @override
  String getUrl() =>
      "${Url.categoryVideoUrl}id=$categoryId&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=Android";

  @override
  String? getNextUrl(Issue model) =>
      "${model.nextPageUrl}&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=Android";
}
