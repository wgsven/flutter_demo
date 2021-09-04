import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/utils/cached_network_image_provider.dart';
import 'package:flutter_open/utils/date_utils.dart';

class VideoItemWidget extends StatefulWidget {
  final Data? data;
  final Function? callback;

  // 是否开启hero动画，默认为false
  final bool openHero;
  final Color titleColor;
  final Color categoryColor;

  const VideoItemWidget(
      {Key? key,
      this.data,
      this.callback,
      this.openHero = false,
      this.titleColor = Colors.white,
      this.categoryColor = Colors.white})
      : super(key: key);

  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.callback != null) {
          widget.callback!();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: <Widget>[
            _videoCover(),
            _vidoeDesc(),
          ],
        ),
      ),
    );
  }

  _videoCover() {
    return Stack(
      children: [
        _coverImage(),
        _coverTime(),
      ],
    );
  }

  _coverImage() {
    if (widget.openHero) {
      return Hero(
        tag: "${widget.data?.id}${widget.data?.time}",
        child: _coverImageReal(),
      );
    } else {
      return _coverImageReal();
    }
  }

  _coverImageReal() {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: cacheImage(widget.data?.cover?.feed ?? "url",
          width: 135, height: 80, fit: BoxFit.cover),
    );
  }

  _coverTime() {
    return Positioned(
        right: 5,
        bottom: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(color: Colors.black54),
            padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
            child: Text(
              formatDateMs(widget.data?.duration != null
                  ? widget.data!.duration! * 1000
                  : 0),
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

  _vidoeDesc() {
    return Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _vidoeTitle(),
            _vidoeCategory(),
          ],
        ));
  }

  _vidoeTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        widget.data?.title ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: widget.titleColor,
            fontSize: 14,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  _vidoeCategory() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Text(
        "${widget.data?.category ?? ""}/${widget.data?.description}",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: widget.categoryColor, fontSize: 12),
      ),
    );
  }
}
