import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/data/preferences.dart';
import 'package:flutter_annotations/utils/constants.dart';
import 'package:flutter_annotations/utils/utils.dart';

class Styles {
  static final String fontNameDefault = 'FontLetra';

//  static final String fontNameDefault = 'Font';
  static final _textSizeTitle = 18.0;
  static final _textBigTitle = 40.0;
  static final _textSizeDefault = 16.0;
  static final _textSizeDescription = 13.0;
  static Color titleColor ;
  static Color subtitleColor ;
  static Color placeholderColor ;
  static Color iconColor ;
  static Color progressColor ;
  static Color backgroundColor ;
  static ThemeData themeData ;

//  static const Color backgroundColor = Colors.white;

  static ThemeData themeDark (){
    titleColor = Colors.white;
    subtitleColor = Colors.white;
    iconColor = Colors.white;
    progressColor = colorParse(hexCode: '#F26430');
    backgroundColor = colorParse(hexCode: '#1D2026');
    placeholderColor = colorParse(hexCode: '#323640');
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      brightness: Brightness.dark,
      primaryColor: backgroundColor,
      accentColor: progressColor,
      indicatorColor: progressColor,
    );
  }

  static ThemeData themeLight(){
    titleColor = Colors.black;
    subtitleColor = Colors.black;
    iconColor = colorParse(hexCode: '#F26430');
    progressColor =  colorParse(hexCode: '#F26430');
    backgroundColor = colorParse(hexCode: '#ffffff');
    placeholderColor = Colors.grey[200];
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      brightness: Brightness.light,
      primaryColor: backgroundColor,
      accentColor: progressColor,
    );
  }
//  static iniTheme({ThemeType themeType = ThemeType.Light}){
//    themeType =  Tools.onThemeType();
//    themeData = themeType == ThemeType.Light ? themeLight() : themeDark();
//  }

  static styleTitle(
          {Color color,
          bool size = true,
          FontWeight fontWeight = FontWeight.bold}) =>
      TextStyle(
          fontSize: size ? _textSizeTitle : _textBigTitle,
          fontWeight: fontWeight,
          color: color);

  static styleDefault(
          {Color color,
          FontWeight fontWeight = FontWeight.normal,
          bool size = true}) =>
      TextStyle(
          fontSize: size ? _textSizeTitle : _textBigTitle,
//          fontFamily: fontNameDefault,
          fontWeight: fontWeight,
          color: color);

  static styleDescription(
          {Color color,
          double textSizeDescription = 0,
          FontWeight fontWeight = FontWeight.normal}) =>
      TextStyle(
          fontSize: textSizeDescription == 0
              ? _textSizeDescription
              : textSizeDescription,
          fontWeight: fontWeight,
//          fontFamily: fontNameDefault,
          color: color);
}
