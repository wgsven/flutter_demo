import 'package:flutter/material.dart';
import 'package:flutter_open/viewmodel/base_widget.dart';
import 'package:flutter_open/viewmodel/home/home_body_viewmodel.dart';
import 'package:flutter_open/widget/banner_widget.dart';
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
      onModelInit: (model) => model.refresh(),
      builder: (BuildContext context, HomeBodyVm model, Widget? child) {
        return LoadingStateWidget(
            viewState: model.viewState,
            retry: model.retry,
            child: _banner(model));
      },
    );
  }

  _banner(model){
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 15,top: 15,right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: BannerWidget(model: model),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
