import 'package:flutter/material.dart';
import 'package:flutter_open/viewmodel/base_widget.dart';
import 'package:flutter_open/viewmodel/home/home_body_viewmodel.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';

class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<HomeBodyVm>(
      model: HomeBodyVm(),
      onModelInit:(model) => model.refresh(),
      builder: (BuildContext context, HomeBodyVm model, Widget? child) {
        return LoadingStateWidget(
            viewState: ViewState.error,
            retry: model.retry,
            child: Container(
              color: Colors.red,
            ));
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
