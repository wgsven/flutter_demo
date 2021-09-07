import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/model/discovery/category_model.dart';
import 'package:flutter_open/state/base_list_state.dart';
import 'package:flutter_open/utils/cached_network_image_provider.dart';
import 'package:flutter_open/utils/navigator_utils.dart';
import 'package:flutter_open/viewmodel/discovery/category_detail_viewmodel.dart';
import 'package:flutter_open/widget/list_item_widget.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel categoryModel;

  const CategoryDetailPage({Key? key, required this.categoryModel})
      : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState
    extends BaseListState<Item, CategoryDetailViewModel, CategoryDetailPage> {
  @override
  bool enablePullDown() => false;

  @override
  CategoryDetailViewModel get viewModel =>
      CategoryDetailViewModel(widget.categoryModel.id ?? 14);

  @override
  Widget getContentChild(CategoryDetailViewModel model) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          _sliverAppbar(),
          _sliverListItem(model),
        ],
      ),
    );
    ;
  }

  Widget _sliverAppbar() {
    return SliverAppBar(
        //展开高度
        expandedHeight: 200,
        //设置为true时，当SliverAppBar内容滑出屏幕时，将始终渲染一个固定在顶部的收起状态
        pinned: true,
        //收起/展开状态默认背景色,
        backgroundColor: Colors.white,
        //收起状态时显示的返回按钮
        leading: GestureDetector(
          onTap: () => back(),
          child: Icon(
            Icons.arrow_back,
            // color: isExpend ? Colors.greenAccent : Colors.black,//无效
            color: Colors.black,
          ),
        ),
        flexibleSpace: _flexibleSpace());
  }

  //收起和展开
  Widget _flexibleSpace() {
    return LayoutBuilder(builder: (context, constraints) {
      changeExpendStatus(
        (MediaQuery.of(context).padding.top).toInt() + 56,
        constraints.biggest.height.toInt(),
      );
      return FlexibleSpaceBar(
        title: Text(
          widget.categoryModel.name ?? "",
          style: TextStyle(color: isExpend ? Colors.white : Colors.black),
        ),
        centerTitle: false,
        background: cacheImage(widget.categoryModel.headerImage ?? "",
            fit: BoxFit.cover),
      );
    });
  }

  // 判断是否展开，从而改变字体颜色
  bool isExpend = true;

  void changeExpendStatus(int statusBarHeight, int offset) {
    if (offset > statusBarHeight && offset < 250) {
      if (!isExpend) {
        isExpend = true;
      }
    } else {
      if (isExpend) {
        isExpend = false;
      }
    }
  }

  Widget _sliverListItem(CategoryDetailViewModel model) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return ListItemWidget(
          item: model.itemList[index],
        );
      }, childCount: model.itemList.length),
    );
  }
}
