import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_annotations/core/data/preferences.dart';

import 'object_event.dart';


class ConfigAppEvent extends ObjectEvent {
  @override
  String toString() => 'ConfigAppEvent';
}

class InitConfig extends ConfigAppEvent {
  @override
  String toString() => 'InitConfig';
}

class ConfigChangeTheme extends ConfigAppEvent {
  final ThemeType themeType;
  ConfigChangeTheme(this.themeType);
  @override
  String toString() => 'ConfigChangeTheme';
}

class ConfigChangeLanguage extends ConfigAppEvent {
  final Locale locale;
  ConfigChangeLanguage(this.locale);
  @override
  String toString() => 'ConfigChangeLanguage';
}
