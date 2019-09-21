import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../core/model/domain/anotation.dart';
import '../core/model/domain/content.dart';
import '../core/model/enums/view_state.dart';
import '../utils/constants.dart';

class BaseModel extends ChangeNotifier {
  Database database;
  bool _widgetActived = false;
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  BaseModel() {
    initDatabase();
  }

  setActived(bool value) {
    this._widgetActived = value;
  }

  actived() {
    return _widgetActived;
  }

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future<List<Content>> contentsAllAnotation(int id) async {
    List<Map> jsons = await this.database.rawQuery(
        'select * from $DB_ANOTATION_TABLE_CONTENT where id_anotation = ${id} order by id desc');
    var contents = jsons.map((json) => Content.fromJsonMap(json)).toList();
    return contents != null ? contents : List<Content>();
  }

  Future<bool> exist_annotation(int id) async {
    var query =
        'select * from $DB_ANOTATION_TABLE_NAME where id_anotation = ${id}';
    List<Map> jsons = await this.database.rawQuery(query);
    return jsons != null && jsons.length > 0 ? true : false;
  }

  Future<int> insertOrUpadate(Anotation anotation) async {
    int result = -1;
    try {
      if (anotation.id_anotation > 0) {
        result = await updateAnotation(anotation);
      } else {
        result = await insertAnotation(anotation);
      }
    } catch (ex) {
      print('insertOrUpadate:Error ${ex.toString()}');
      result = -1;
    }
    return result;
  }

  Future<int> countItemsAnottaion({int id}) async {
    if (database == null) {
      await initDatabase();
    }
    var jsons = await this.database.rawQuery(
        'select count(*) as numItems from $DB_ANOTATION_TABLE_CONTENT where id_anotation = ${id} order by id desc');
    return jsons.map((json) => json['numItems']).toList()[0];
  }

  Future<int> insertContent(Anotation anotation, Content content) async {
    int result = -1;
    await this.database.transaction((Transaction t) async {
      result = await t.rawInsert(
          '''insert into $DB_ANOTATION_TABLE_CONTENT (value,createdAt,modifiedAt,type_content,id_anotation) values (
              "${content.value}", 
              "${content.createdAt.millisecondsSinceEpoch}",
              "${content.modifiedAt.millisecondsSinceEpoch}",
              "${content.type_content}",
              "${content.id_anotation}")
          ''');
      if (result > 0) {
        insertOrUpadate(anotation);
      }
    });
    print('insert: ${result}');
    return result;
  }

  Future<int> insertAnotation(Anotation anotation) async {
    int result = -1;
    await this.database.transaction((Transaction t) async {
      result = await t.rawInsert(
          '''insert into $DB_ANOTATION_TABLE_NAME (title,description,color,createdAt,modifiedAt) values (
              "${anotation.title}",
              "${anotation.description}",
              "${anotation.color}",
              "${anotation.createdAt.millisecondsSinceEpoch}",
              "${anotation.modifiedAt.millisecondsSinceEpoch}")
          ''');
    });
    print('insert: ${result}');
    return result;
  }

  Future<int> updateAnotation(Anotation anotation) async {
    int result = -1;
    await this.database.transaction((Transaction t) async {
      result = await t.rawInsert(
          '''update  $DB_ANOTATION_TABLE_NAME set modifiedAt = ${DateTime.now().millisecondsSinceEpoch}
             where id_anotation = ${anotation.id_anotation}''');
    });
    print('updateAnotation: ${result}');
    return result;
  }

  Future initDatabase() async {
    setState(ViewState.Busy);
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, DB_NAME_FILE);
    this.database = await openDatabase(dbPath, version: 3,
        onCreate: (Database db, int version) async {
      await db.execute(SCRIPT_ANOTATION);
      await db.execute(SCRIPT_CONTENT);
    });
  }
}
