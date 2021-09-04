import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/state/base_list_state.dart';
import 'package:flutter_open/viewmodel/home/home_body_viewmodel.dart';
import 'package:flutter_open/widget/banner_widget.dart';
import 'package:flutter_open/widget/list_item_widget.dart';

const TEXT_HEADER_TYPE = 'textHeader';

class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeBodyState();
}

class _HomeBodyState extends BaseListState<Item, HomeBodyVm, HomeBody> {
  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return ProviderWidget<HomeBodyVm>(
  //     model: HomeBodyVm(),
  //     onModelInit: (model) => model.refresh(),
  //     builder: (BuildContext context, HomeBodyVm model, Widget? child) {
  //       return LoadingStateWidget(
  //           viewState: model.viewState,
  //           retry: model.retry,
  //           child: _banner(model));
  //     },
  //   );
  // }

  _banner(model) {
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 15, top: 15, right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: BannerWidget(model: model),
      ),
    );
  }

  @override
  Widget getContentChild(HomeBodyVm model) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Offstage(
          offstage: index == 0 || model.itemList[index].type == TEXT_HEADER_TYPE
              ? true
              : false,
          child: Divider(
            height: 0.5,
            color: Colors.black12,
          ),
        );
      },
      itemCount: model.itemList.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _banner(model);
        } else {
          if (TEXT_HEADER_TYPE == model.itemList[index].type) {
            return _itemTitle(model.itemList[index]);
          } else {
            return ListItemWidget(item: model.itemList[index]);
          }
        }
      },
    );
  }




  ///item的标题
  _itemTitle(Item item) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        item.data!.text!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  HomeBodyVm get viewModel => HomeBodyVm();
}
