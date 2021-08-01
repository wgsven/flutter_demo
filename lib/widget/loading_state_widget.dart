import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/config/color.dart';
import 'package:flutter_open/config/string.dart';

enum ViewState { loading, done, error }

class LoadingStateWidget extends StatefulWidget {
  final ViewState viewState;

  final VoidCallback retry;
  final Widget child;

  LoadingStateWidget(
      {Key? key,
      required this.viewState,
      required this.retry,
      required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingState();
}

class _LoadingState extends State<LoadingStateWidget> {
  @override
  Widget build(BuildContext context) {
    if (ViewState.loading == widget.viewState) {
      return _loading;
    } else if (ViewState.error == widget.viewState) {
      return _error;
    } else {
      return widget.child;
    }
  }

  Widget get _error {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/ic_error.png",
            width: 36,
            height: 36,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              WgsvenString.net_request_fail,
              style: TextStyle(fontSize: 18, color: WgsvenColor.hitTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: OutlinedButton(
              onPressed: widget.retry,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.black12)),
              child: Text(
                WgsvenString.reload_again,
                style: TextStyle(fontSize: 18, color: WgsvenColor.hitTextColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get _loading {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
