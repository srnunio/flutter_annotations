import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/data/preferences.dart';
import 'package:flutter_annotations/core/listeners/actions.dart';
import 'package:flutter_annotations/core/model/domain/anotation.dart';
import 'package:flutter_annotations/ui/widget/annotation_item.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_annotations/utils/constants.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_annotations/utils/utils.dart';
import 'package:sqflite/sqlite_api.dart';
import 'bloc_base.dart';
import 'object_event.dart';
import 'object_state.dart';

class AnnotationBloc extends AnnotationBase {
  @override
  get initialState => ObjectUninitialized();

  void updateSortList(SortListing listing) {
    Tools.updateSort(listing);
    dispatch(Run());
  }

  void updateAvatarMode(LetterType letterType) async {
    Tools.updateLetterType(letterType);
    dispatch(Reload());
  }

  Future changeLanguageDialog(
      BuildContext context, ActionListener actionListener) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 280,
              decoration: BoxDecoration(
                  color: Styles.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Translations.current.text('language'),
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
                    onTap: () async {
                      Navigator.pop(context);
                      await Tools.updateLanguage('pt');
                      actionListener.onChangeLanguage(Locale('pt'));
                    },
                    title: Text(
                      Translations.current.text('portuguese'),
                      maxLines: 1,
                      style: Styles.styleTitle(color: Styles.titleColor),
                    ),
                    trailing: Checkbox(
                        value: Translations.current.locale.languageCode
                            .contains('pt'),
                        onChanged: null),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Tools.updateLanguage('en');
                      actionListener.onChangeLanguage(Locale('en'));
                    },
                    title: Text(
                      Translations.current.text('english'),
                      maxLines: 1,
                      style: Styles.styleTitle(color: Styles.titleColor),
                    ),
                    trailing: Checkbox(
                        value: Translations.current.locale.languageCode
                            .contains('en'),
                        onChanged: null),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Tools.updateLanguage('es');
                      actionListener.onChangeLanguage(Locale('es'));
                    },
                    title: Text(
                      Translations.current.text('spanish'),
                      maxLines: 1,
                      style: Styles.styleTitle(color: Styles.titleColor),
                    ),
                    trailing: Checkbox(
                        value: Translations.current.locale.languageCode
                            .contains('es'),
                        onChanged: null),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      Translations.current.text('cancel'),
                      maxLines: 1,
                      style: Styles.styleDescription(color: Styles.titleColor),
                    ),
                  )
                ],
              ),
            ),
          );
        });
//    _switchColorDialog(context);
  }

  Future detailItem(int index, BuildContext context) {
    var annotation = (currentState as ObjectLoaded).objects[index];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext c) {
          return AnnotationDetail(anotation: annotation);
        });
  }

  Future deleteItemDialog(int index, BuildContext context) async {
    var annotation =
        ((currentState as ObjectLoaded).objects[index] as Annotation);

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
                      annotation.title,
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
                            var result = await _deleteAnotation(
                                id: annotation.id_anotation);
                            if (result != -1) {
                              (currentState as ObjectLoaded)
                                  .objects
                                  .removeAt(index);
                              dispatch(Reload());
                              messageToas(
                                  message: Translations.current
                                      .text('message_delete_anotation'));
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

  Future<int> _deleteAnotation({int id}) async {
    int result = -1;
    if (await countItemsAnottaionDb(id: id) > 0) {
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

  Future<List<Annotation>> _readAnnotations() async {
    List<Annotation> annotations = [];
    if (database == null) await initDB();

    try {
      await Tools.onLetterType();
      var sort = await Tools.onSortListing();
      var filter =
          sort == SortListing.CreatedAt ? 'createdAt desc' : 'modifiedAt desc ';
      var query = 'select * from $DB_ANOTATION_TABLE_NAME order by ${filter} ';
      List<Map> jsons = await this.database.rawQuery(query);
      for (Map json in jsons) {
        var anotation = Annotation.fromJsonMap(json);
        anotation
            .setContents(await contentsAllAnotation(anotation.id_anotation));
        annotations.add(anotation);
      }
    } catch (ex) {
      print('Exception => ${ex.toString()}');
    }
    return annotations;
  }

  @override
  Stream<ObjectState> mapEventToState(ObjectEvent event) async* {
    print('AnnotationBloc : mapEventToState => ${event}');
//    print('AnnotationBloc : mapEventToState : currentState => ${currentState}');
    if (event is Run) {
      try {
        if (currentState is ObjectUninitialized) {
          var annotations = await _readAnnotations();
          update = false;
          yield ObjectLoaded(objects: annotations, hasReachedMax: false);
          return;
        }
        if (currentState is ObjectLoaded) {

          var annotations = await _readAnnotations();
          update = false;
          yield annotations.isEmpty
              ? (currentState as ObjectLoaded).copyWith(hasReachedMax: true)
              : ObjectLoaded(objects: annotations, hasReachedMax: false);
        }
      } catch (_) {
        update = false;
        yield ObjectError();
      }
    } else if (event is Reload) {
      var newList = (currentState as ObjectLoaded)
          .objects
          .sublist(0, (currentState as ObjectLoaded).objects.length);
      (currentState as ObjectLoaded).objects.clear();
      update = false;
      yield ObjectLoaded(objects: newList, hasReachedMax: false);
    } else if (event is Refresh) {
      update = false;
      yield ObjectRefresh();
    }
  }

  AnnotationBloc() : super();
}
