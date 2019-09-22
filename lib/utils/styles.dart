import 'dart:ui';

import 'package:flutter/material.dart';
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

//  static const Color backgroundColor = Colors.white;

  static iniTheme(){
//    titleColor = Colors.white;
//    subtitleColor = Colors.white;
//    iconColor = Colors.white;
//    progressColor =  colorParse(hexCode: '#F26430');
//    backgroundColor = colorParse(hexCode: '#1D2026');
//    placeholderColor = colorParse(hexCode: '#323640');

    titleColor = Colors.black;
    subtitleColor = Colors.black;
    iconColor = colorParse(hexCode: '#F26430');
    progressColor =  colorParse(hexCode: '#F26430');
    backgroundColor = colorParse(hexCode: '#ffffff');
    placeholderColor = Colors.grey[200];

//    titleColor =  colorParse(hexCode: '#F26430');
//    backgroundColor = Colors.black;
//    iconColor = colorParse(hexCode: '#F26430');
//    progressColor = Colors.white;
  }

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
