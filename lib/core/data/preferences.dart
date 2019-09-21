import 'package:avatar_letter/avatar_letter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortListing { CreatedAt, ModifiedAt }

class Tools {
  static SharedPreferences prefs;
  static LetterType letterType;
  static SortListing sortListing;
  static final LETTER_KEY = 'DesignItem';
  static final SORT_KEY = 'SortListing';

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static updateLetterType(LetterType type) {
    prefs.setString(LETTER_KEY, '${type}');
  }

  static updateSort(SortListing type) {
    prefs.setString(SORT_KEY, '${type}');
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
