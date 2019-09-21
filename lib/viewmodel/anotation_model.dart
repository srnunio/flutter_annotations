
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import '../core/data/preferences.dart';
import '../core/model/domain/anotation.dart';
import '../core/model/enums/view_state.dart';
import '../locator.dart';
import '../ui/widget/anotation_widget.dart';
import '../utils/Translations.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';
import '../utils/utils.dart';
import 'base_model.dart';

class AnotationModel extends BaseModel {
  List<Anotation> anotations;
  BuildContext _context;

  Future init(BuildContext buildContext) async {
    await initDatabase();
    setContext(buildContext);
    setActived(true);
    read_items();
  }

  Future initSearch(BuildContext buildContext) async {
    await initDatabase();
    setContext(buildContext);
    setActived(true);
    setState(ViewState.Empty);
  }

  setContext(BuildContext context) {
    this._context = context;
  }

  context() {
    return _context;
  }

  void updateSortList(SortListing listing){
    Tools.updateSort(listing);
    read_items();
  }

  void updateAvatarMode(LetterType letterType){

    Tools.updateLetterType(letterType);
    refresh();
  }

  Future search(String value) async {
    if (anotations == null) {
      this.anotations = List<Anotation>();
    }
    setState(ViewState.Busy);
    var query =
        'select * from $DB_ANOTATION_TABLE_NAME where title like ${"'%$value%'"}';
    print('query = ${query}');
    List<Map> jsons = await this.database.rawQuery(query);
    anotations.clear();
    for (Map json in jsons) {
      var anotation = Anotation.fromJsonMap(json);
      this.anotations.add(anotation);
    }
    setState(anotations.length > 0 ? ViewState.Idle : ViewState.Empty);
  }


  Future items() async {
    if (anotations == null) {
      this.anotations = List<Anotation>();
    }
    await Tools.onLetterType();
    var sort = await Tools.onSortListing();
    var filter = sort == SortListing.CreatedAt ? 'createdAt desc' : 'modifiedAt desc ';
    var query =
        'select * from $DB_ANOTATION_TABLE_NAME order by ${filter} ';
    List<Map> jsons = await this.database.rawQuery(query);
    anotations.clear();
    for (Map json in jsons) {
      var anotation = Anotation.fromJsonMap(json);
      anotation.setContents(
          await contentsAllAnotation(anotation.id_anotation));
      this.anotations.add(anotation);
    }
    await Future.delayed(Duration(seconds: 1));
    setState(anotations.length > 0 ? ViewState.Idle : ViewState.Empty);
  }

  Future detailItem(int position) {
    Anotation anotation = anotations[position];

    showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (BuildContext c) {
          return AnnotationDetail(anotation: anotation);
        });
  }

  Future deleteItem(int index) async {
    var delete = false;
    var anotation = anotations[index];
    showDialog<String>(
        context: _context,
        builder: (BuildContext c) {
          return AlertDialog(
            title: Text(
              anotation.title,
              style: Styles.styleTitle(color: colorParse(hexCode: COLOR_DEFAULT)),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    delete = false;
                    Navigator.pop(_context);
                  },
                  child: Text(
                    Translations.current.text('no'),
                    style: Styles.styleDescription(textSizeDescription: 16.0,color: Colors.red),
                  )),
              FlatButton(
                  onPressed: () {
                    delete = true;
                    Navigator.pop(_context);
                  },
                  child: Text(
                    Translations.current.text('yes'),
                    style: Styles.styleDescription(textSizeDescription: 16.0,
                        color: colorParse(hexCode: COLOR_DEFAULT)),
                  )),
            ],
            content: Container(
              width: double.maxFinite,
              child: Text(
                Translations.current.text('delete_anotation'),
                style:
                Styles.styleDescription(textSizeDescription: 16.0,color:Colors.black),
              ),
            ),
          );
        }).then<String>((onValue) async {
      if (delete) {
        var result = await _deleteAnotation(id: anotation.id_anotation);
        if (result != -1) {
          anotations.removeAt(index);
          if (anotations.length > 0) {
            setState(ViewState.Idle);
          } else {
            setState(ViewState.Empty);
          }
          messageToas(
              message: Translations.current.text('message_delete_anotation'));
        } else {
          messageToas(
              message:
                  Translations.current.text('message_delete_error_anotation'));
        }
      }
      return onValue;
    });
  }

  Future<int> _deleteAnotation({int id}) async {
    int result = -1;
    if (await countItemsAnottaion(id: id) > 0) {
      await this.database.transaction((Transaction t) async {
        result = await t.rawInsert(
            '''delete  from $DB_ANOTATION_TABLE_CONTENT where id_anotation = ${id}''');
      });
      print('deleteAnotation:${result}');
    }
    await this.database.transaction((Transaction t) async {
      result = await t.rawInsert(
          '''delete  from $DB_ANOTATION_TABLE_NAME where id_anotation = ${id}''');
    });

    print('update: ${result}');
    return result;
  }

  Future read_items() async {

    setState(ViewState.Busy);
    try {
      await items();
    } catch (ex) {
      print("read_items:Error ${ex.toString()}");
      setState(ViewState.Empty);
    }
  }

  Future refresh() async {
    print('AnotationModel:refresh');
    var auxs = anotations.toList();
    anotations.clear();
    anotations.addAll(auxs);
    setState(ViewState.Refresh);
    setState(ViewState.Idle);
    await items();
  }
}
