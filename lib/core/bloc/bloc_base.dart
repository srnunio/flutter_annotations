import 'dart:io';

import 'package:flutter_annotations/core/model/domain/anotation.dart';
import 'package:flutter_annotations/core/model/domain/content.dart';
import 'package:flutter_annotations/utils/constants.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'object_event.dart';
import 'object_state.dart';
import 'package:bloc/bloc.dart';

abstract class AnnotationBase extends Bloc<ObjectEvent, ObjectState> {
  Database database;
  bool update = false;
  initDB() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, DB_NAME_FILE);
    this.database = await openDatabase(dbPath, version: 4,
        onCreate: (Database db, int version) async {
      await db.execute(SCRIPT_ANOTATION);
      await db.execute(SCRIPT_CONTENT);
    });
  }

  Future<List<Content>> contentsAllAnotation(int id) async {
    List<Content> contents = [];
    try {
      String query =
          'select * from $DB_ANOTATION_TABLE_CONTENT where id_anotation = ${id} order by id desc';
//      print('contentsAllAnotation|query : ${query}');
      List<Map> jsons = await this.database.rawQuery(query);
      contents = jsons.map((json) => Content.fromJsonMap(json)).toList();
    } catch (ex) {
      print('contentsAllAnotation => ${ex.toString()}');
    }
    return contents != null ? contents : List<Content>();
  }

  Future<bool> existAnnotationDb(String title) async {
    var query =
        'select * from $DB_ANOTATION_TABLE_NAME where title = ${"'${title}'"}';
    List<Map> jsons = await this.database.rawQuery(query);
    return jsons != null && jsons.length > 0 ? true : false;
  }

  Future<int> insertOrUpadateDb(Annotation anotation ,{String column = ''}) async {
    int result = -1;
//    print('insertOrUpadate:column ${column}');
    try {
      if (anotation.id_anotation > 0) {
        result = await updateAnotationDb(anotation,column:column);
      } else {
        result = await insertAnotationDb(anotation);
      }
    } catch (ex) {
      print('insertOrUpadate:Error ${ex.toString()}');
      result = -1;
    }
    return result;
  }

  Future<int> countItemsAnottaionDb({int id}) async {
    if (database == null) {
      await initDB();
    }
    var jsons = await this.database.rawQuery(
        'select count(*) as numItems from $DB_ANOTATION_TABLE_CONTENT where id_anotation = ${id} order by id desc');
    return jsons.map((json) => json['numItems']).toList()[0];
  }

  Future<int> insertContentDb(Annotation anotation, Content content) async {
    int result = -1;
    try {
      await this.database.transaction((Transaction t) async {
        result = await t.rawInsert(
            '''insert into $DB_ANOTATION_TABLE_CONTENT (value,createdAt,modifiedAt,id_anotation) values (
              "${content.value}", 
              "${content.createdAt.millisecondsSinceEpoch}",
              "${content.modifiedAt.millisecondsSinceEpoch}",
              "${content.id_anotation}")
          ''');
        if (result > 0) {
          insertOrUpadateDb(anotation);
        }
      });
      print('insert: ${result}');
    } catch (ex) {
      print('insertContentDb ${ex.toString()}');
    }
    return result;
  }

  Future<int> insertAnotationDb(Annotation anotation) async {
    int result = -1;
    var query =  '''insert into $DB_ANOTATION_TABLE_NAME (title,color,createdAt,modifiedAt) values (
              "${anotation.title}",
              "${anotation.color}",
              "${anotation.createdAt.millisecondsSinceEpoch}",
              "${anotation.modifiedAt.millisecondsSinceEpoch}")
          ''';
    await this.database.transaction((Transaction t) async {
      result = await t.rawInsert(query);
    });
//    print('query: ${query}');
    print('insert: ${result}');
    return result;
  }


  Future<int> updateAnotationDb(Annotation anotation, {String column = ''}) async {
    int result = -1;

    var query = '';
    if(column.contains(AnnotationColumn.TITLE)){
      query = anotation.title;
    }else  if(column.contains(AnnotationColumn.COLOR)){
      query = anotation.color;
    }
    column = column.length > 0 ? ', ${column} = ?' : '';
    await this.database.transaction((Transaction t) async {
      result = await t.rawUpdate('UPDATE $DB_ANOTATION_TABLE_NAME SET modifiedAt = ? ${column} WHERE id_anotation = ?',
          query.isEmpty ? ['${DateTime.now().millisecondsSinceEpoch}', '${anotation.id_anotation}']:['${DateTime.now().millisecondsSinceEpoch}', '${query}', '${anotation.id_anotation}']);
    });
//    print('query = : ${query}');
    print('updateAnotation: ${result}');
    return result;
  }

  AnnotationBase() {
    initDB();
  }
}
