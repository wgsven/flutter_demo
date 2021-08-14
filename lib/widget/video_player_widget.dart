import 'package:chewie/chewie.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String playerUrl;
  final bool autoPlay;
  final bool allowFullScreen;
  final bool allowPlaybackSpeedChanging;
  final bool looping;
  final double aspectRatio;

  const VideoPlayerWidget({
    Key? key,
    required this.playerUrl,
    this.autoPlay = true,
    this.allowFullScreen = true,
    this.allowPlaybackSpeedChanging = true,
    this.looping = true,
    this.aspectRatio = 16 / 9,
  }) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    debugPrint("playerUrl = ${widget.playerUrl}");
    _videoPlayerController = VideoPlayerController.network(widget.playerUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: widget.autoPlay,
      allowFullScreen: widget.allowFullScreen,
      allowPlaybackSpeedChanging: widget.allowPlaybackSpeedChanging,
      aspectRatio: widget.aspectRatio,
      looping: widget.looping,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil.getInstance().screenWidth;
    double height = width / widget.aspectRatio;
    return Container(
      width: width,
      height: height,
      child: Chewie(controller: _chewieController!),
    );
  }

  void play() {
    _chewieController?.play();
  }

  void pause() {
    _chewieController?.pause();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
