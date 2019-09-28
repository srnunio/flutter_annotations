import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_annotations/core/data/preferences.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_annotations/utils/styles.dart';

import 'config_event.dart';

class ConfigApp {
  ThemeData themeData = Styles.themeLight();
  Locale locale = Translations.current.locale;
}

class ConfigAppBloc extends Bloc<ConfigAppEvent, ConfigApp> {
  @override
  ConfigApp get initialState => ConfigApp();

  ThemeType themeType;
  ConfigApp configApp;

  ConfigAppBloc() {
    themeType = Tools.onThemeType();
    configApp = ConfigApp();
    dispatch(InitConfig());
  }

  ThemeData _onTheme(ThemeType themeType){
    return themeType == ThemeType.Light
        ? Styles.themeLight()
        : Styles.themeDark();
  }

  @override
  Stream<ConfigApp> mapEventToState(ConfigAppEvent event) async* {
    configApp = ConfigApp();
    if (event is InitConfig) {
      configApp.locale = await Tools.onLanguage();
      configApp.themeData = themeType == ThemeType.Light
          ? Styles.themeLight()
          : Styles.themeDark();
      yield configApp;
    } else if (event is ConfigChangeTheme) {
      var configTheme = (event as ConfigChangeTheme);
      themeType = configTheme.themeType;
      Tools.updateTheme(configTheme.themeType);
      configApp.themeData = _onTheme(themeType);
      yield configApp;
    } else if (event is ConfigChangeLanguage) {
      var configLanguage = (event as ConfigChangeLanguage);
      Tools.updateLanguage(configLanguage.locale.languageCode);
      configApp.locale = configLanguage.locale;
      configApp.themeData =_onTheme(themeType);
      yield configApp;
    }
  }
}
