
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import '../core/model/domain/anotation.dart';
import '../core/model/domain/content.dart';
import '../core/model/enums/view_state.dart';
import '../locator.dart';
import '../utils/Translations.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';
import '../utils/utils.dart';
import 'anotation_model.dart';
import 'base_model.dart';

class ContentModel extends BaseModel {
  Anotation anotation;
  List<Content> contents;
  BuildContext _context;

  Future init(Anotation anotation,BuildContext context) async {
    this.anotation = anotation;
    this._context = context;
    await initDatabase();
    contents = new List<Content>();
    read_items();
  }

  Future deleteItem(int index) async {
    var delete = false;
    var content = contents[index];
    showDialog<String>(
        context: _context,
        builder: (BuildContext c) {
          return AlertDialog(
            backgroundColor: Styles.placeholderColor,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    delete = false;
                    Navigator.pop(_context);
                  },
                  child: Text(
                    Translations.current.text('no'),
                    style: Styles.styleDescription(fontWeight:FontWeight.bold,textSizeDescription: 16.0,color: Colors.red),
                  )),
              FlatButton(
                  onPressed: () {
                    delete = true;
                    Navigator.pop(_context);
                  },
                  child: Text(
                    Translations.current.text('yes'),
                    style: Styles.styleDescription(fontWeight:FontWeight.bold,textSizeDescription: 16.0,
                        color: Styles.iconColor),
                  )),
            ],
            content: Container(
              width: double.maxFinite,
              child: Text(
                Translations.current.text('delete'),
                style:
                Styles.styleDescription(textSizeDescription: 16.0,color:Styles.titleColor),
              ),
            ),
          );
        }).then<String>((onValue) async {
      if (delete) {
        var result = await _deleteContent(id: content.id);
        if (result != -1) {
          contents.removeAt(index);
          if (contents.length > 0) {
            setState(ViewState.Idle);
          } else {
            setState(ViewState.Empty);
          }
          messageToas(
              message: Translations.current.text('deleted'));
        } else {
          messageToas(
              message:
              Translations.current.text('message_delete_error_anotation'));
        }
      }
      return onValue;
    });
  }
  Future<int> _deleteContent({int id}) async {
    int result = -1;
      await this.database.transaction((Transaction t) async {
        result = await t.rawInsert(
            '''delete  from $DB_ANOTATION_TABLE_CONTENT where id = ${id}''');
      });
      print('deleteAnotation:${result}');
    return result;
  }
  Future items() async {
//    List<Map> jsons = await this.database.rawQuery(
//        'select * from $DB_ANOTATION_TABLE_CONTENT where id_anotation = ${anotation.id_anotation} order by id desc');
    this.contents = await contentsAllAnotation(anotation.id_anotation);

    if (contents.length > 0) {
      setState(ViewState.Idle);
    } else {
      setState(ViewState.Empty);
    }
  }

  Future read_items() async {
    try {
      print("read_items loading");
      setState(ViewState.Busy);
      if (anotation.id_anotation > 0) {
        setState(ViewState.Busy);
        await items();
      } else {
        setState(ViewState.Empty);
      }
      print("read_items:read");
    } catch (ex) {
      print("Error ${ex.toString()}");
      setState(ViewState.Empty);
    }
  }

  Future addContent(String string) async {
    print("addContent : ${string}");
    var content = Content(
        value: string,
        type_content: 1,
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
        id_anotation: anotation.id_anotation);
    contents.insert(0, content);
    if (anotation.id_anotation > 0) {
      await insertContent(anotation, content);
      setState(ViewState.Idle);
    } else {
      setState(ViewState.Idle);
    }
  }

  Future<String> save_anotation(BuildContext context) async{
    bool save = false;
    bool exist = false;
    TextEditingController _textEditingController = TextEditingController();
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return AlertDialog(
            backgroundColor: Styles.placeholderColor,
            title: Text(Translations.current.text('name_annotation'),style: Styles.styleDescription(fontWeight:FontWeight.bold,color: Styles.titleColor),),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    save = false;
                    Navigator.pop(context);
                  },
                  child: Text(
                    Translations.current.text('cancel'),
                    style: Styles.styleDescription(fontWeight:FontWeight.bold,color: Colors.red),
                  )),
              FlatButton(
                  onPressed: () {

                    if(anotation.title.isEmpty){
                      save = false;
                      messageToas(message: Translations.current.text(
                          'message_alert_name_annotation'));
                    }else{
                      save = true;
                      Navigator.pop(context);
                    }

                  },
                  child: Text(
                    Translations.current.text('save'),
                    style: Styles.styleDescription(
                      fontWeight: FontWeight.bold,
                        color: Styles.iconColor),
                  )),
            ],
            content: Container(
              width: double.maxFinite,
              child: TextField(
                controller: _textEditingController,
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                    counterStyle: Styles.styleDescription(color: Styles.titleColor),
                    filled: true,
                    hintText: Translations.current.text('name_annotation')),
                onChanged: (text) {
                  anotation.setTitle(text);
                },
//                onSubmitted: (String text) {
//                  addContent(text);
//                },
              ),
            ),
          );
        }).then<String>((onValue) async {
      if (save) {
        if (anotation.id_anotation <= 0) {
          anotation = Anotation(
            title: anotation.title,
            color: coloRandom(),
            description: "",
            createdAt: DateTime.now(),
            modifiedAt: DateTime.now(),
          );
        } else {
          exist = await exist_annotation(anotation.id_anotation);
          anotation.setModifiedAt(DateTime.now());
        }

          if (anotation.title != null && anotation.title.length > 0) {
            if (exist) {
              messageToas(message: Translations.current.text(
                  'message_alert_exist_annotation'));
            } else {
              var value = await insertOrUpadate(anotation);
              if (value > 0) {
                anotation = Anotation(
                  id_anotation: value,
                  title: anotation.title,
                  color: anotation.color,
                  description: anotation.description,
                  createdAt: anotation.createdAt,
                  modifiedAt: DateTime.now(),
                );
                messageToas(message: Translations.current.text(
                    'message_done_save_annotation'));
                locator.get<AnotationModel>().refresh();
//               read_items();
              } else {
                messageToas(message: Translations.current.text(
                    'message_error_save_annotation'));
              }
            }
          }

      }
      return onValue;
    });
  }
}
