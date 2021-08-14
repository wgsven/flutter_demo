import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/utils/cached_network_image_provider.dart';
import 'package:flutter_open/utils/date_utils.dart';

///列表item
class ListItemWidget extends StatefulWidget {
  final Item item;

  const ListItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          _cover(widget.item),
          _author(widget.item),
        ],
      ),
    );
  }

  _cover(item) {
    return Stack(
      children: <Widget>[
        _coverBanner(item),
        _coverCatergory(item),
        _coverTime(item),
      ],
    );
  }

  _coverBanner(Item item) {
    return GestureDetector(
      onTap: () {
        debugPrint("点击了item=${item.data?.id}");
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: cacheImage(item.data!.cover!.feed!,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  _coverCatergory(Item item) {
    return Positioned(
      left: 15,
      top: 10,
      child: ClipOval(
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 44,
          height: 44,
          color: Colors.white70,
          alignment: Alignment.center,
          child: Text(
            item.data!.category!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  _coverTime(Item item) {
    return Positioned(
        right: 15,
        bottom: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: Colors.black54),
          child: Text(
            formatDateMs(item.data?.duration == null
                ? 0
                : (item.data!.duration! * 1000)),
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ));
  }

  _author(Item item) {
    return Row(
      children: <Widget>[
        _authorIcon(item),
        _authorDesc(item),
        _share(item),
      ],
    );
  }

  _authorIcon(Item item) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(22))),
      child: ClipOval(
        clipBehavior: Clip.antiAlias,
        child: cacheImage(
            item.data?.author?.icon == null ? "" : item.data!.author!.icon!,
            fit: BoxFit.cover,
            width: 44,
            height: 44),
      ),
    );
  }

  _authorDesc(Item item) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.data?.title == null ? "" : item.data!.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              item.data?.description == null ? "" : item.data!.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  _share(Item item) {
    return IconButton(
        onPressed: () {
          debugPrint("点击分享");
        },
        icon: const Icon(Icons.share));
  }
}
