import 'dart:io';
import 'dart:ui';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_annotations/utils/Translations.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';

enum SortListing { CreatedAt, ModifiedAt }
enum ThemeType { Dark, Light }

class Tools {
  static SharedPreferences prefs;
  static LetterType letterType;
  static SortListing sortListing;
  static final LETTER_KEY = 'DesignItem';
  static final SORT_KEY = 'SortListing';
  static final ThemeType_KEY = 'ThemeType';
  static final LANGUAGE = 'LANGUAGE';

  static final  Languages = ['pt', 'en', 'es'];

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static updateLetterType(LetterType type) {
    letterType = type;
    prefs.setString(LETTER_KEY, '${type}');
  }

  static updateSort(SortListing type) {
    sortListing = type;
    prefs.setString(SORT_KEY, '${type}');
  }

  static updateLanguage(String code) async {
    prefs.setString(LANGUAGE,code.trim());
    await Translations.load(Locale(code));
  }

  static updateTheme(ThemeType type) {
    prefs.setString(ThemeType_KEY, '${type}');
  }

  static Future<Locale> onLanguage() async {
    String code = prefs.getString(LANGUAGE) ??  Platform.localeName;
    print('onLanguage : ${code}');
    return Translations.filterLocale(Locale(code));
  }

  static ThemeType onThemeType() {
    var type = prefs.getString(ThemeType_KEY) ?? null;
    return (type == null)
        ? ThemeType.Light
        : (type == '${ThemeType.Light}') ? ThemeType.Light : ThemeType.Dark;
  }

  static Future<SortListing> onSortListing() async {
    var type = prefs.getString(SORT_KEY);
    sortListing = (type == null)
        ? SortListing.CreatedAt
        : (type == '${SortListing.ModifiedAt}')
            ? SortListing.ModifiedAt
            : SortListing.CreatedAt;
    return sortListing;
  }

  static Future<LetterType> onLetterType() async {
    var type = prefs.getString(LETTER_KEY);
    letterType = (type == null)
        ? LetterType.Rectangle
        : (type == '${LetterType.None}')
            ? LetterType.None
            : (type == '${LetterType.Circular}')
                ? LetterType.Circular
                : LetterType.Rectangle;
    return letterType;
  }
}
