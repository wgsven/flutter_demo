import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open/model/common_item.dart';
import 'package:flutter_open/utils/cached_network_image_provider.dart';
import 'package:flutter_open/utils/navigator_utils.dart';
import 'package:flutter_open/viewmodel/base_widget.dart';
import 'package:flutter_open/viewmodel/video/video_body_viewmodel.dart';
import 'package:flutter_open/viewmodel/video/video_item_widget.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';
import 'package:flutter_open/widget/video_player_widget.dart';

const VIDEO_SMALL_CARD_TYPE = 'videoSmallCard';

class VideoDetailPage extends StatefulWidget {
  final Data? data;

  const VideoDetailPage({Key? key, this.data}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> with WidgetsBindingObserver{
  late final Data data;
  final GlobalKey<VideoPlayerWidgetState> videoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    data = widget.data == null ? arguments() : widget.data;
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      videoKey.currentState?.play();
    }else if(state == AppLifecycleState.paused) {
      videoKey.currentState?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<VideoBodyViewModel>(
        model: VideoBodyViewModel(),
        onModelInit: (model) => model.loadVideoData(data.id ?? -1),
        builder: (context, model, child) {
          return _scaffold(model);
        });
  }

  _scaffold(VideoBodyViewModel model) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ///状态栏
          AnnotatedRegion(
              child: Container(
                height: MediaQuery.of(context).padding.top,
                color: Colors.black,
              ),
              value: SystemUiOverlayStyle.light),
          ///视频,
          VideoPlayerWidget(key:videoKey,playerUrl: data.playUrl!),
          ///视频底部列表信息
          Expanded(
              flex: 1,
              child: LoadingStateWidget(
                viewState: model.viewState,
                retry: model.retry,
                child: Container(
                  decoration: _decoration(),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      _sliversDesc(),
                      _sliversList(model),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  _decoration() {
    //图片背景
    return BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: cachedNetworkImageProvider(
                "${data.cover!.blurred}}/thumbnail/${MediaQuery.of(context).size.height}x${MediaQuery.of(context).size.width}")));
  }

  _sliversDesc() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _videoTitle(),
          _videoDesc(),
          _videoState(),
        ],
      ),
    );
  }

  _videoTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10, right: 15),
      child: Text(
        data.title ?? "",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  _videoDesc() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15, bottom: 10, right: 15),
      child: Text(
        data.description ?? "",
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  ///点赞分享转发
  _videoState() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
      child: Row(
        children: [
          _rowState("images/ic_like.png",
              "${data.consumption?.collectionCount ?? 0}"),
          _rowState("images/ic_share_white.png",
              "${data.consumption?.shareCount ?? 0}"),
          _rowState("images/icon_comment.png",
              "${data.consumption?.replyCount ?? 0}"),
        ],
      ),
    );
  }

  _rowState(String image, String desc) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 22,
            height: 22,
          ),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              desc,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  ///其他视频列表
  _sliversList(VideoBodyViewModel model) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        if (VIDEO_SMALL_CARD_TYPE == model.itemList[index].type) {
          return VideoItemWidget(
            data: model.itemList[index].data,
            callback: () {
              Navigator.pop(context);
              toPage(VideoDetailPage(
                data: model.itemList[index].data,
              ));
            },
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              model.itemList[index].data?.text ?? "",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          );
        }
      },
      childCount: model.itemList.length,
    ));
  }
}
