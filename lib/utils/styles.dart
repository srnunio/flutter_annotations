import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static final String fontNameDefault = 'FontLetra';

//  static final String fontNameDefault = 'Font';
  static final _textSizeTitle = 18.0;
  static final _textBigTitle = 40.0;
  static final _textSizeDefault = 16.0;
  static final _textSizeDescription = 13.0;

  static const Color backgroundColor = Colors.white;

// const Color backgroundColor = Color.fromARGB(255, 255, 241, 159);
  static styleTitle(
          {Color color,
          bool size = true,
          FontWeight fontWeight = FontWeight.bold}) =>
      TextStyle(
          fontSize: size ? _textSizeTitle : _textBigTitle,
          fontWeight: fontWeight,
//          fontFamily: fontNameDefault,
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
