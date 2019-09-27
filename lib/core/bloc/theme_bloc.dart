import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_annotations/core/data/preferences.dart';
import 'package:flutter_annotations/utils/styles.dart';

class ThemeBloc extends Bloc<ThemeType, ThemeData> {
  @override
  ThemeData get initialState => Styles.themeLight();
  ThemeType themeType;

  ThemeBloc(){
    themeType = Tools.onThemeType();
    dispatch(themeType);
  }

  @override
  Stream<ThemeData> mapEventToState(ThemeType event) async* {
    Tools.updateTheme(event);
    themeType = event;
    switch (event) {
      case ThemeType.Light:
        yield Styles.themeLight();
        break;
      case ThemeType.Dark:
        yield Styles.themeDark();
        break;
    }
  }
}
