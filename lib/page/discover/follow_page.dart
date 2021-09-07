import 'package:flutter/material.dart';
import 'package:flutter_open/config/color.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/state/base_list_state.dart';
import 'package:flutter_open/viewmodel/discovery/follow_viewmodel.dart';
import 'package:flutter_open/widget/discovery/follow_item_widget.dart';

class FollowPage extends StatefulWidget {
  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState
    extends BaseListState<Item, FollowViewModel, FollowPage> {
  @override
  Widget getContentChild(FollowViewModel model) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.5,
          color: WgsvenColor.hitTextColor,
        );
      },
      itemCount: model.itemList.length,
      itemBuilder: (BuildContext context, int index) {
        return FollowItemWidget(item :model.itemList[index]);
      },
    );
  }

  @override
  FollowViewModel get viewModel => FollowViewModel();
}
