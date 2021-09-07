import 'package:flutter/material.dart';
import 'package:flutter_open/model/paging_model.dart';
import 'package:flutter_open/viewmodel/base_list_viewmodel.dart';
import 'package:flutter_open/viewmodel/base_widget.dart';
import 'package:flutter_open/widget/loading_state_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListState<L, M extends BaseListViewModel<L, PagingModel<L>>,
        T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  M get viewModel;

  Widget getContentChild(M model);

  bool enablePullUp() {
    return true;
  }

  bool enablePullDown() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<M>(
        model: viewModel,
        onModelInit: (model) => model.refresh(),
        builder: (context, model, child) {
          return LoadingStateWidget(
            viewState: model.viewState,
            retry: model.retry,
            child: SmartRefresher(
              controller: model.refreshController,
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              enablePullUp: enablePullUp(),
              //是否能上拉加载更多
              enablePullDown: enablePullDown(),
              //是否能下拉刷新
              child: getContentChild(model),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
