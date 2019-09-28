import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';
import 'Translations.dart';

String formatDate(String value, {bool format = false}) {
  var now = DateTime.parse(value);
  var formatter = DateFormat(
      format ? 'dd' : 'dd.MM.yyyy', Translations.current.locale.languageCode);
  return format
      ? '${formatter.format(now)} ${_weekday(now)}'
      : formatter.format(now);
}

void messageToas({String message}) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black.withOpacity(0.7),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      textColor: Colors.white,
      fontSize: 16.0);
}

String _weekday(DateTime dateTime) {
  var day = weekday(dateTime);
  return day.length > 3 ? day.substring(0, 3) : day;
}

String weekday(DateTime dateTime) {
  switch (dateTime.weekday) {
    case 1:
      return Translations.current.text('Monday');
    case 2:
      return Translations.current.text('Tuesday');
    case 3:
      return Translations.current.text('Wednesday');
    case 4:
      return Translations.current.text('Thursday');
    case 5:
      return Translations.current.text('Friday');
    case 6:
      return Translations.current.text('Saturday');
    case 7:
      return Translations.current.text('Sunday');
  }
}

String coloRandom() {
  RandomColor _randomColor = RandomColor();
  Color _color = _randomColor.randomColor();
  return '#${_color.value.toRadixString(16).toUpperCase()}';
//  var random = Random();
//  int limit = COLORS_LIST.length;
//  String color = COLORS_LIST.toList()[random.nextInt(limit)];
//  return color;
}

colors({int size = 19}) {
  List<String> _colors = [];
  while (size >= 0) {
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor();
    _colors.add('#${_color.value.toRadixString(16).toUpperCase()}');
    size--;
  }
  return _colors;
}

String runeSubstring({String input, int start, int end}) {
  return String.fromCharCodes(input.runes.toList().sublist(start, end));
}

String formatText({String value}) {
  return String.fromCharCodes(value.runes.toList());
}

String letter({String value}) {
  try {
//    value = String.fromCharCode(value.runes.first);
//    var array = value.toString().trim().split(' ');
//    print('letter: ${array}');
//    if (array != null && array.length > 1) {
//      return runeSubstring(input: array[0],start: 0,end: 1);
//    }
    return '${runeSubstring(input: value, start: 0, end: value.length)}';
//    return numLetter > 1 ? '${value[0]}${value[1]}' : value[0];
  } catch (ex) {}
  return '?';
}

progressWidget() {
  return Center(child: CircularProgressIndicator());
}

//
String formatHora(String value) {
  var now = DateTime.parse(value);
  var formatter = DateFormat('hh:mm', Translations.current.locale.languageCode);
  return formatter.format(now);
}

Color parseColor({String hexCode}) {}

Color colorParse({String hexCode}) {
  try {
    String hex = hexCode.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
      '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex
          .substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }catch(_){}
  return Colors.black;
}
