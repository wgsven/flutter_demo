import 'package:flutter/material.dart';
import 'package:flutter_open/utils/cached_network_image_provider.dart';
import 'package:flutter_open/utils/get_materialapp_widget.dart';
import 'package:flutter_open/utils/navigator_utils.dart';
import 'package:flutter_open/viewmodel/home/home_body_viewmodel.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class BannerWidget extends StatefulWidget {
  final HomeBodyVm model;

  const BannerWidget({Key? key, required this.model}) : super(key: key);

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: cachedNetworkImageProvider(
                          widget.model.banners ? [index].data?.cover?.feed
                              ?.toString() ??
                              "",
                        ))),
              ),
              Positioned(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 30,
                  //置于底部
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 15),
                    decoration: BoxDecoration(color: Colors.black12),
                    child: Text(
                      widget.model.banners ? [index].data?.title ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 19),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
            ],
          );
        },
        onTap: (index) {
          debugPrint("点击了第$index个banner");
          toName(ROUTE_VIDEO_DETAIL, widget.model.banners![index].data);
        },
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            builder: SwiperPagination.dots
        ),
        itemCount: widget.model.banners?.length ?? 0);
  }
}
