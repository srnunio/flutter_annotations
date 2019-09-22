
import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_state/flutter_lifecycle_state.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import '../../viewmodel/base_model.dart';


class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onStartModel;


  BaseView({this.builder, this.onStartModel});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends StateWithLifecycle<BaseView<T>> {
  T model = locator<T>();

  @override
  void onCreate() {
    if (widget.onStartModel != null) {
      widget.onStartModel(model);
    }
    super.onCreate();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        builder: (context) => model,
        child: Consumer<T>(builder: widget.builder));
  }
}