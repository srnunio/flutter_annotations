import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/data/preferences.dart';
import 'package:flutter_annotations/core/model/domain/anotation.dart';
import 'package:flutter_annotations/core/model/domain/content.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_annotations/utils/constants.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_annotations/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sqflite/sqlite_api.dart';
import 'bloc_base.dart';
import 'object_event.dart';
import 'object_state.dart';
import 'package:rxdart/rxdart.dart';

class ContentAnnotationBloc extends AnnotationBase {
//  List<Content> contents = [];
  Annotation _annotation;

  Annotation get annottation => _annotation;

  @override
  get initialState => ObjectUninitialized();

  Future settingsDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 180,
              decoration: BoxDecoration(
                  color: Styles.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Translations.current.text('options'),
                    maxLines: 1,
                    style: Styles.styleTitle(color: Styles.titleColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Container(
                      color: Styles.placeholderColor,
                    ),
                    height: 0.5,
                    width: double.infinity,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      saveAnnotationDialog(context, rename: true);
                    },
                    title: Text(
                      Translations.current.text('rename'),
                      maxLines: 1,
                      style: Styles.styleTitle(color: Styles.titleColor),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _switchColorDialog(context);
                    },
                    title: Text(
                      Translations.current.text('change_color'),
                      maxLines: 1,
                      style: Styles.styleTitle(color: Styles.titleColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
//    _switchColorDialog(context);
  }

  Future _switchColorDialog(BuildContext context) {
    List<String> _colors = colors();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 420,
              decoration: BoxDecoration(
                  color: Styles.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: GridView.count(
                  primary: true,
                  crossAxisCount: 4,
                  childAspectRatio: 1.00,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  children: List.generate(_colors.length, (index) {
                    var color = _colors[index];
                    if (index == _colors.length - 1) {
                      return IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _switchColorDialog(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/add.svg',
                          height: 24,
                          width: 24,
                          color: Styles.iconColor,
                        ),
                      );
                    }
                    if (index == _colors.length - 4) {
                      return IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/cancel.svg',
                          height: 24,
                          width: 24,
                          color: Styles.iconColor,
                        ),
                      );
                    }
                    return IconButton(
                        icon: AvatarLetter(
                          letterType: Tools.letterType,
                          text: '?',
                          backgroundColorHex: color,
                          textColorHex: color,
                        ),
                        onPressed: () async {
                          print('color: ${color}');
                          _annotation.color = color;
                          var result = await updateAnotationDb(_annotation,
                              column: AnnotationColumn.COLOR);
                          print('_annotation.color: ${_annotation.color}');
                          if (result > 0) {
                            messageToas(
                                message: Translations.current.text('update'));
                            dispatch(Reload());
                          } else {
                            messageToas(
                                message:
                                    Translations.current.text('error_update'));
                          }
                          Navigator.pop(context);
                        });
                  })),
            ),
          );
        });
  }

  Future<int> _deleteContent({int id}) async {
    int result = -1;
    await this.database.transaction((Transaction t) async {
      result = await t.rawInsert(
          '''delete  from $DB_ANOTATION_TABLE_CONTENT where id = ${id}''');
    });
    return result;
  }

  Future deleteItemDialog(int index, BuildContext context) async {
    var content = ((currentState as ObjectLoaded).objects[index] as Content);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 180,
              decoration: BoxDecoration(
                  color: Styles.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      content.value,
                      maxLines: 1,
                      style: Styles.styleTitle(color: Styles.titleColor),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      Translations.current.text('delete_anotation'),
                      style: Styles.styleDescription(
                          textSizeDescription: 16.0,
                          color: Styles.subtitleColor),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            Translations.current.text('no'),
                            style: Styles.styleDescription(
                                fontWeight: FontWeight.bold,
                                textSizeDescription: 16.0,
                                color: Colors.red),
                          )),
                      FlatButton(
                          onPressed: () async {
                            var result = await _deleteContent(id: content.id);
                            if (result != -1) {
                              (currentState as ObjectLoaded)
                                  .objects
                                  .removeAt(index);

                              dispatch(Run());
                              messageToas(
                                  message:
                                      Translations.current.text('deleted'));
                            } else {
                              messageToas(
                                  message: Translations.current
                                      .text('message_delete_error_anotation'));
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            Translations.current.text('yes'),
                            style: Styles.styleDescription(
                                fontWeight: FontWeight.bold,
                                textSizeDescription: 16.0,
                                color: Styles.titleColor),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool> saveAnnotationDialog(BuildContext context,
      {bool rename = false}) async {
    bool save = false;
    bool exist = false;
    TextEditingController _textEditingController = TextEditingController();

    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 220,
              decoration: BoxDecoration(
                  color: Styles.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Translations.current.text('name_annotation'),
                    style: Styles.styleDescription(
                        textSizeDescription: 18,
                        fontWeight: FontWeight.bold,
                        color: Styles.titleColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _annotation.id_anotation > 0
                      ? Text(
                          Translations.current.text('title_alert'),
                          style: Styles.styleDescription(
                              textSizeDescription: 16,
                              color: Styles.subtitleColor),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: TextField(
                      controller: _textEditingController,
                      keyboardAppearance: Brightness.light,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      autofocus: true,
                      decoration: InputDecoration(
                          counterStyle:
                              Styles.styleDescription(color: Styles.titleColor),
                          filled: true,
                          hintText: _annotation.id_anotation > 0
                              ? _annotation.title
                              : Translations.current.text('name_annotation')),
                      onChanged: (text) {
                        _annotation.setTitle(text);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            save = false;
                            Navigator.pop(context);
                          },
                          child: Text(
                            Translations.current.text('cancel'),
                            style: Styles.styleDescription(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          )),
                      FlatButton(
                          onPressed: () async {
                            if (_annotation.title.isEmpty) {
                              save = false;
                              messageToas(
                                  message: Translations.current
                                      .text('message_alert_name_annotation'));
                            } else {
                              if (_annotation.id_anotation <= 0) {
                                _annotation = Annotation(
                                  title: _annotation.title,
                                  color: coloRandom(),
                                  createdAt: DateTime.now(),
                                  modifiedAt: DateTime.now(),
                                );
                              } else {
                                exist =
                                    await existAnnotationDb(_annotation.title);
                                _annotation.setModifiedAt(DateTime.now());
                              }

                              if (_annotation.title != null &&
                                  _annotation.title.length > 0) {
                                if (exist) {
                                  messageToas(
                                      message: Translations.current.text(
                                          'message_alert_exist_annotation'));
                                } else {
                                  var value = await insertOrUpadateDb(
                                      _annotation,
                                      column:
                                          rename ? AnnotationColumn.TITLE : '');
                                  if (value > 0) {
                                    _annotation = Annotation(
                                      id_anotation: value,
                                      title: _annotation.title,
                                      color: _annotation.color,
                                      createdAt: _annotation.createdAt,
                                      modifiedAt: DateTime.now(),
                                    );
                                    save = true;
                                    messageToas(
                                        message: Translations.current.text(
                                            'message_done_save_annotation'));

                                    if ((currentState as ObjectLoaded)
                                            .objects
                                            .length >
                                        0) {
                                      _saveAllContents();
                                    }
//                                    dispatch(Run());

                                  } else {
                                    messageToas(
                                        message: Translations.current.text(
                                            'message_error_save_annotation'));
                                  }
                                }
                              }
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
                  )
                ],
              ),
            ),
          );
        });
    return save;
  }

  Future _saveAllContents() async {
    for (Content content in (currentState as ObjectLoaded).objects) {
      if (content.id_anotation <= 0) {
        content.id_anotation = _annotation.id_anotation;
        await insertContentDb(_annotation, content);
      }
    }
  }

  Future<bool> insertContent(String value) async {
    if (value == null || value.isEmpty) return false;

    var result = -1;
    var newContent = Content(
        value: value,
        modifiedAt: DateTime.now(),
        createdAt: DateTime.now(),
        id_anotation: annottation.id_anotation);

    (currentState as ObjectLoaded).objects.insert(0, newContent);
    dispatch(Reload());
    if (annottation.id_anotation > 0) {
      result = await insertContentDb(annottation, newContent);
    }
    return result > 0 ? true : false;
  }

  Stream<ObjectState> transformEvents(Stream<ObjectEvent> events,
      Stream<ObjectState> Function(ObjectEvent event) next) {
    return super.transformEvents(
        (events as Observable<ObjectEvent>)
            .debounceTime(Duration(milliseconds: 500)),
        next);
  }

  Future<List<Content>> _readContents() async {
    if (database == null) await initDB();

    if (_annotation == null) return [];

    List<Content> contents = [];
    try {
      contents = await contentsAllAnotation(_annotation.id_anotation);
    } catch (_) {
      print('Exception');
    }
    return contents;
  }

  @override
  Stream<ObjectState> mapEventToState(ObjectEvent event) async* {
    if (event is Run) {
      try {
        if (currentState is ObjectUninitialized) {
          var contents = await _readContents();
          yield ObjectLoaded(objects: contents, hasReachedMax: false);
          return;
        }
        if (currentState is ObjectLoaded) {
          var contents = await _readContents();
          yield contents.isEmpty
              ? (currentState as ObjectLoaded).copyWith(hasReachedMax: true)
              : ObjectLoaded(objects: contents, hasReachedMax: false);
        }
      } catch (_) {
        yield ObjectError();
      }
    }
    else if (event is Reload) {
      var newList = (currentState as ObjectLoaded)
          .objects
          .sublist(0, (currentState as ObjectLoaded).objects.length);
      (currentState as ObjectLoaded).objects.clear();
      (currentState as ObjectLoaded).objects.addAll(newList);
      yield ObjectLoaded(
          objects: (currentState as ObjectLoaded).objects,
          hasReachedMax: true);
    }
  }

  ContentAnnotationBloc(this._annotation) : super();
}
