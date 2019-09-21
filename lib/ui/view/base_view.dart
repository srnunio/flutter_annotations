import 'package:anotacoes/locator.dart';
import 'package:anotacoes/viewmodel/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_state/flutter_lifecycle_state.dart';
import 'package:provider/provider.dart';


class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final Function(T) onModelChanged;
  final Function(T) onModelPaused;


  BaseView({this.builder, this.onModelReady,this.onModelChanged,this.onModelPaused});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends StateWithLifecycle<BaseView<T>> {
  T model = locator<T>();

  @override
  void onCreate() {
    print('------ onCreate -------');
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.onCreate();
  }


//  @override
//  void didUpdateWidget(StatefulWidget oldWidget) {
//    // TODO: implement didUpdateWidget
//    if (widget.onModelResume != null) {
//      widget.onModelResume(model);
//    }
//    super.didUpdateWidget(oldWidget);
//  }
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    // TODO: implement didChangeAppLifecycleState
//   print('didChangeAppLifecycleState ${state}');
//   if (widget.onModelResume != null) {
//     widget.onModelResume(model);
//   }
//    super.didChangeAppLifecycleState(state);
//  }


  @override
  void deactivate() {
    if (widget.onModelChanged != null) {
      widget.onModelChanged(model);
    }
    super.deactivate();
  }

  @override
  void onPause() {
    if (widget.onModelPaused != null) {
      widget.onModelPaused(model);
    }
    super.onPause();
  }
//  @override
//  void initState() {
//    if (widget.onModelReady != null) {
//      widget.onModelReady(model);
//    }
//    super.initState();
//  }



//  @override
//  void dispose() {
//    // TODO: implement dispose
//    if (widget.onModelCloser != null) {
//      widget.onModelCloser(model);
//    }
//    super.dispose();
//  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        builder: (context) => model,
        child: Consumer<T>(builder: widget.builder));
  }
}