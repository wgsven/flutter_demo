import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:chewie/src/material/material_progress_bar.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/utils/date_utils.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';

///默认安卓效果
// class VideoPlayerControllerWidget extends MaterialControls{
// }
///默认ios效果
// class VideoPlayerControllerWidget extends CupertinoControls {
//   VideoPlayerControllerWidget()
//       : super(backgroundColor: Colors.redAccent, iconColor: Colors.blue);
// }
class VideoPlayerControllerWidget extends StatefulWidget {
  ///外部传入的顶部ui
  final Widget? overlayUi;

  const VideoPlayerControllerWidget({Key? key, this.overlayUi})
      : super(key: key);

  @override
  _VideoPlayerControllerWidgetState createState() =>
      _VideoPlayerControllerWidgetState();
}

class _VideoPlayerControllerWidgetState extends State<
        VideoPlayerControllerWidget> //SingleTickerProviderStateMixin这个主要是配合AnimationController使用
    with
        SingleTickerProviderStateMixin {
  // late VideoPlayerNotifier notifier;
  ///当前是否隐藏加载进度
  bool _hideStuff = true;

  ///音量
  late double _latestVolume;

  ///亮度
  late double _latestBrightness;

  ///上一次播放位置
  late VideoPlayerValue _latestValue;

  ///点击之后，隐藏controller,计时器
  Timer? _hideTimer;

  ///第一次进入视频播放页面，隐藏controller，计时器
  Timer? _initTimer;

  ///全屏切换timer
  Timer? _showAfterExpandCollapseTimer;

  ///当前是否在拖拽
  bool _dragging = false;

  ///
  bool _displayTapped = false;

  //底部控制栏高度
  final barHeight = 48.0 * 1.5;
  final marginSize = 5.0;
  late VideoPlayerController controller;
  ChewieController? _chewieController;

  // We know that _chewieController is set in didChangeDependencies
  ChewieController get chewieController => _chewieController!;

  // 播放暂停图标动画控制器
  late final playPauseIconAnimationController = AnimationController(
    vsync: this,
    // value: widget.playing ? 1 : 0,
    duration: const Duration(milliseconds: 400),
    reverseDuration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    // notifier = Provider.of<VideoPlayerNotifier>(context, listen: false);
  }

  ///初始化信息
  @override
  void didChangeDependencies() {
    final _oldController = _chewieController;
    _chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }
    super.didChangeDependencies();
  }

  Future<void> _initialize() async {
    _latestVolume = controller.value.volume;
    controller.addListener(_updateState);
    _updateState();
    if (controller.value.isPlaying || chewieController.autoPlay) {
      _startHideTimer();
    }
    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          // notifier.hideStuff = false;
          _hideStuff = false;
        });
      });
    }
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    //播放错误的时候
    if (_latestValue.hasError) {
      return chewieController.errorBuilder?.call(
            context,
            chewieController.videoPlayerController.value.errorDescription!,
          ) ??
          const Center(
            child: Icon(
              Icons.error,
              color: Colors.white,
              size: 42,
            ),
          );
    }
    //正常播放
    return _playVideo();
  }

  ///开始长按事件，重置变量
  double moveDistance = 0;
  double lastY = 0.0;
  double videoHight = 0;

  ///是否改变音量,
  bool isChangeVolume = false;
  double tempVolume = 0;

  ///是否改变亮度
  bool isChangeBright = false;
  double tempBrightness = 0;

  void _onLongPressEnd(LongPressEndDetails details) {
    //控制提示隐藏
    setState(() {
      _hideTip = true;
    });
  }

  void _onLongPressStart(LongPressStartDetails details) async {
    _latestVolume = controller.value.volume;
    _latestBrightness = await ScreenBrightness.current;
    debugPrint("_latestBrightness=$_latestBrightness====_latestVolume=$_latestVolume");
    videoHight = context.size?.height ?? getDefaultHeight();
    moveDistance = 0;
    lastY = details.localPosition.dy;
    if (details.globalPosition.dx > ScreenUtil.getInstance().screenWidth / 2) {
      isChangeVolume = true;
      isChangeBright = false;
      _tipsText =
      "当前音量:${(double.parse(_latestVolume.toStringAsFixed(2)) * 100).toStringAsFixed(0)}";
    } else {
      isChangeVolume = false;
      isChangeBright = true;
      _tipsText =
      "当前亮度:${(double.parse(_latestBrightness.toStringAsFixed(2)) * 100).toStringAsFixed(0)}";
    }
    //控制提示显示
    setState(() {
      _hideTip = false;
    });
  }

  double getDefaultHeight() {
    if (chewieController.isFullScreen) {
      return ScreenUtil.getInstance().screenHeight;
    } else {
      return ScreenUtil.getInstance().screenHeight /
          (chewieController.aspectRatio ?? 16 / 9);
    }
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    moveDistance += details.localPosition.dy - lastY;
    // debugPrint("lastY=$lastY-newY=${details.localPosition.dy}");
    lastY = details.localPosition.dy;
    if (isChangeBright) {
      tempBrightness = (moveDistance / videoHight + _latestBrightness);
      if (tempBrightness >= 1) {
        tempBrightness = 1;
      } else if (tempBrightness <= 0) {
        tempBrightness = 0;
      }
      _tipsText = "当前亮度:${(double.parse(tempBrightness.toStringAsFixed(2)) * 100).toStringAsFixed(0)}";
      ScreenBrightness.setScreenBrightness(tempBrightness);
    } else if (isChangeVolume) {
      tempVolume = (moveDistance / videoHight + _latestVolume);
      if (tempVolume >= 1) {
        tempVolume = 1.0;
      } else if (tempVolume <= 0) {
        tempVolume = 0;
      }
      // debugPrint("moveDistance=$moveDistance/videoHeight=$videoHight=value=$tempVolume");
      _tipsText = "当前音量:${(double.parse(tempVolume.toStringAsFixed(2)) * 100).toStringAsFixed(0)}";
      chewieController.setVolume(tempVolume);
    }
  }

  Widget _playVideo() {
    return GestureDetector(
      onTap: () => _cancelAndRestartTimer(),
      onLongPressStart: _onLongPressStart,
      onLongPressMoveUpdate: _onLongPressMoveUpdate,
      onLongPressEnd: _onLongPressEnd,

      /// AbsorbPointer:禁止用户输入的控件，会消耗掉事件，跟 IgnorePointer(不消耗事件) 类似
      child: AbsorbPointer(
        // absorbing：true 不响应事件
        // absorbing: notifier.hideStuff,
        absorbing: _hideStuff,
        child: Stack(
          children: [
            Column(
              children: [
                //中间控制器，大播放、暂停按钮
                _centerArea(),
                //底部控制器
                _buildBottomBar(context)
              ],
            ),

            ///顶部浮层，后放置的控件先响应事件
            _overlayUI(),

            ///提示文字
            _tipsUi(),
          ],
        ),
      ),
    );
  }

  bool _hideTip = true;
  String _tipsText = "";

  Widget _tipsUi() {
    return Offstage(
      offstage: _hideTip,
      child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          decoration: BoxDecoration(
            color: Colors.black54,
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              _tipsText,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  ///中间控制器，大播放、暂停按钮
  Widget _centerArea() {
    return Expanded(
      flex: 1,
      child: _latestValue.isBuffering
          ?
          //正在缓冲,显示进度条
          const Center(
              child: CircularProgressIndicator(),
            )
          :
          // 创建点击区，就是控制器
          _buildHitArea(),
    );
  }

  Widget _buildHitArea() {
    //视频播放是否结束
    final bool isFinished = _latestValue.position >= _latestValue.duration;

    return GestureDetector(
      onTap: () {
        if (_latestValue.isPlaying) {
          if (_displayTapped) {
            setState(() {
              _hideStuff = true;
            });
          } else {
            _cancelAndRestartTimer();
          }
        } else {
          _playPause();

          setState(() {
            _hideStuff = true;
          });
        }
      },

      ///中间的播放、暂停大按钮
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: !_latestValue.isPlaying && !_dragging ? 1.0 : 0.0,
            // opacity: isFinished && !_dragging ? 1.0 : 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _playPauseButton(isFinished),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///中间大播放、暂停按钮
  Widget _playPauseButton(isFinished) {
    return IconButton(
      onPressed: _playPause,
      iconSize: 32,
      icon: isFinished
          ? Icon(Icons.replay, color: Colors.white)
          : AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              color: Colors.white,
              size: 32,
              progress: playPauseIconAnimationController),
    );
  }

  ///暂停、播放
  void _playPause() {
    final isFinished = _latestValue.position >= _latestValue.duration;
    setState(() {
      if (controller.value.isPlaying) {
        //暂停
        playPauseIconAnimationController.reverse();
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();
        //播放
        if (!controller.value.isInitialized) {
          controller.initialize().then((_) {
            controller.play();
            playPauseIconAnimationController.forward();
          });
        } else {
          if (isFinished) {
            controller.seekTo(const Duration());
          }
          playPauseIconAnimationController.forward();
          controller.play();
        }
      }
    });
  }

  ///底部播放控制器，播放/暂停 、播放进度条、倍速、音量控制...等等
  AnimatedOpacity _buildBottomBar(BuildContext context) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        child: Row(
          children: [
            // 暂停和播放icon
            _buildPlayPause(controller),
            // 进度条：如果是直播
            if (chewieController.isLive)
              // SizedBox:具有固定宽高的组件,适合控制2个组件之间的空隙
              const SizedBox()
            else
              _buildProgressBar(),
            // // 播放时间：如果是直播
            if (chewieController.isLive)
              const Expanded(child: Text('LIVE'))
            else
              _buildPosition(),
            // // 是否显示播放速度设置按钮
            // if (chewieController.allowPlaybackSpeedChanging)
            //   _buildSpeedButton(controller),
            // // 静音按钮
            if (chewieController.allowMuting) _buildMuteButton(controller),
            // // 全屏按钮
            if (chewieController.allowFullScreen) _buildExpandButton(),
          ],
        ),
      ),
    );
  }

//全屏和非全屏按钮
  Widget _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Icon(
          chewieController.isFullScreen
              ? Icons.fullscreen_exit
              : Icons.fullscreen,
          color: Colors.white,
        ),
      ),
    );
  }

  ///全屏和小屏切换
  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;
      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer =
          Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  ///视频的声音开关
  Widget _buildMuteButton(VideoPlayerController controller) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();
        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0);
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: 5),
        child: Icon(
          _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
          color: Colors.white,
        ),
      ),
    );
  }

  ///播放器当前播放时长/总时长
  Widget _buildPosition() {
    final position = _latestValue.position;
    final duration = _latestValue.duration;
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: RichText(
        text: TextSpan(
            text: "${formatDateMs(position.inMilliseconds)}",
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                  text: "/ ${formatDateMs(duration.inMilliseconds)}",
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  )),
            ]),
      ),
    );
  }

  ///播放进度条
  Widget _buildProgressBar() {
    return Expanded(
      child: MaterialVideoProgressBar(
        controller,
        onDragStart: () {
          setState(() {
            _dragging = true;
          });

          _hideTimer?.cancel();
        },
        onDragEnd: () {
          setState(() {
            _dragging = false;
          });

          _startHideTimer();
        },
        colors: chewieController.materialProgressColors ??
            ChewieProgressColors(
              playedColor: Theme.of(context).accentColor,
              handleColor: Theme.of(context).accentColor,
              bufferedColor: Theme.of(context).backgroundColor.withOpacity(0.5),
              backgroundColor: Theme.of(context).disabledColor.withOpacity(.5),
            ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Icon(
          controller.value.isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  ///顶部浮层,返回按钮
  Widget _overlayUI() {
    if (widget.overlayUi == null) {
      return Container();
    } else {
      return AnimatedOpacity(
        // opacity: notifier.hideStuff ? 0.0 : 1.0,
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: widget.overlayUi,
      );
    }
  }

  ///取消之前的计时，重新计时
  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      // notifier.hideStuff = false;
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  ///隐藏控制器计时
  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        // notifier.hideStuff = true;
        _hideStuff = true;
      });
    });
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
    // playPauseIconAnimationController.dispose();
  }
}
