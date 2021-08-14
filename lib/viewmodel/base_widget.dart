import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final Widget? child;
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelInit;

  ProviderWidget(
      {Key? key,
      required this.model,
      this.child,
      required this.builder,
      this.onModelInit})
      : super(key: key);

  @override
  _ProviderWidgetState createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier> extends State<ProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    if (widget.onModelInit != null ) {
      widget.onModelInit!(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => model,
      child: Consumer(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
