import 'package:flutter/material.dart';

///copy from chewie PlayerNotifier
class VideoPlayerNotifier extends ChangeNotifier {
  VideoPlayerNotifier._(
    bool hideStuff,
  ) : _hideStuff = hideStuff;

  bool _hideStuff;

  bool get hideStuff => _hideStuff;

  set hideStuff(bool value) {
    _hideStuff = value;
    notifyListeners();
  }

  // ignore: prefer_constructors_over_static_methods
  static VideoPlayerNotifier init() {
    return VideoPlayerNotifier._(
      true,
    );
  }
}
