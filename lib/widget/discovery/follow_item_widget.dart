import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/config/color.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/utils/cached_network_image_provider.dart';
import 'package:flutter_open/utils/get_materialapp_widget.dart';
import 'package:flutter_open/utils/navigator_utils.dart';

class FollowItemWidget extends StatelessWidget {
  final Item item;

  const FollowItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          //作者信息
          _author(),
          //固定高度横向列表,
          _portfolio(),
        ],
      ),
    );
  }

  ///作者作品集
  Widget _portfolio() {
    return Container(
      height: 240,
      child: ListView.builder(
          itemCount: item.data?.itemList?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return _portfolioItem(item.data?.itemList?[index]);
          }),
    );
  }

  Widget _portfolioItem(Item? item) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                toName(ROUTE_VIDEO_DETAIL, item?.data);
              },
              child: cacheImage(item?.data?.cover?.feed ?? ""),
            ),
          ),
          Text(
            item?.data?.title ?? "",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              DateUtil.formatDateMs(
                  item?.data?.date ?? DateTime.now().millisecond,
                  format: DateFormats.y_mo_d_h_m),
              style: TextStyle(color: Colors.black12, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  ///作者信息相关
  Widget _author() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        children: [
          _authorIcon(),
          _authorDesc(),
          _authorFollowAction(),
        ],
      ),
    );
  }

  Widget _authorIcon() {
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: cacheImage(item.data?.header?.icon ?? "", width: 44, height: 44),
    );
  }

  Widget _authorDesc() {
    return Expanded(
      flex: 1,
      child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.data?.header?.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: WgsvenColor.desTextColor),
              ),
              Text(
                item.data?.header?.description ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: WgsvenColor.hitTextColor),
              )
            ],
          )),
    );
  }

  Widget _authorFollowAction() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Text(
        "+关注",
        style: TextStyle(fontSize: 14, color: WgsvenColor.hitTextColor),
      ),
    );
  }
}
