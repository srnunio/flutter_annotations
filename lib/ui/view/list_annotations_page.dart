import 'package:avatar_letter/avatar_letter.dart';
import 'package:backdrop/backdrop.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/bloc/annotation_bloc.dart';
import 'package:flutter_annotations/core/bloc/config_event.dart';
import 'package:flutter_annotations/core/bloc/content_bloc.dart';
import 'package:flutter_annotations/core/bloc/object_event.dart';
import 'package:flutter_annotations/core/bloc/object_state.dart';
import 'package:flutter_annotations/core/bloc/config_bloc.dart';
import 'package:flutter_annotations/core/data/preferences.dart';
import 'package:flutter_annotations/core/listeners/actions.dart';
import 'package:flutter_annotations/core/model/domain/anotation.dart';
import 'package:flutter_annotations/ui/widget/annotation_item.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_annotations/utils/constants.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_annotations/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

 AnnotationBloc annotationBloc;
class ListAnnotationPage extends StatelessWidget {
  ConfigAppBloc themeBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    themeBloc = BlocProvider.of<ConfigAppBloc>(context);
    return BlocProvider<AnnotationBloc>(
        builder: (context) => AnnotationBloc(),
        child: BlocBuilder<AnnotationBloc, ObjectState>(
            builder: (context, objectState) {
//          print('objectState ${objectState}');
          return ListAnnotatioView(themeBloc);
        }));
  }
}

class ListAnnotatioView extends StatefulWidget {
  final ConfigAppBloc themeBloc;

  ListAnnotatioView(this.themeBloc);

  @override
  _ListAnnotatioView createState() => _ListAnnotatioView(themeBloc);
}

class _ListAnnotatioView extends State<ListAnnotatioView>
    implements AnnotationMoreListener , ActionListener{
  final ConfigAppBloc themeBloc;


  _ListAnnotatioView(this.themeBloc);

  @override
  void initState() {
    annotationBloc = BlocProvider.of<AnnotationBloc>(context);
    super.initState();
    annotationBloc..dispatch(Run());
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnnotationBloc>(
        builder: (context) => annotationBloc,
        child: BlocBuilder<AnnotationBloc, ObjectState>(
            builder: (context, objectState) {
          if (objectState is ObjectRefresh) {
            annotationBloc.dispatch(Run());
          }
//          print('_HomeAnnotationsPage:objectState ${objectState}');

          return BackdropScaffold(
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/searchPage');
                },
                icon: SvgPicture.asset(
                  'assets/icons/search.svg',
                  height: 24,
                  width: 24,
                  color: Styles.iconColor,
                ),
              ),
            ],
            title: Text(
              Translations.current.text('annotations'),
              textAlign: TextAlign.center,
              style: Styles.styleTitle(color: Styles.titleColor),
            ),
            headerHeight: 450.0,
            backLayer: Container(
              child: Center(
                child: _buildMores(),
              ),
            ),
            frontLayer: _home(),
            iconPosition: BackdropIconPosition.leading,
          );
        }));
  }

  _chipingSort(String text, SortListing listing) {
    if (Tools.sortListing == listing) {
      return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: colorParse(hexCode: COLOR_DEFAULT)),
        child: Text(
          text,
          style: Styles.styleDescription(color: Colors.white),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: null),
      child: Text(
        text,
      ),
    );
  }

  _chipingLeeter(String text, LetterType letterType) {
    if (Tools.letterType == letterType) {
      return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: colorParse(hexCode: COLOR_DEFAULT)),
        child: Text(
          text,
          style: Styles.styleDescription(color: Colors.white),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: null),
      child: Text(
        text,
      ),
    );
  }

  _buildMores() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ExpandableNotifier(
            child: Container(child: Builder(builder: (context) {
              ExpandableController controller =
                  ExpandableController.of(context);
              return Column(
                children: <Widget>[
                  Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Styles.placeholderColor,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Expandable(
                              collapsed: Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Text(
                                  Translations.current.text('sort'),
                                  style: Styles.styleDescription(
                                      textSizeDescription: 16,
                                      color: Styles.titleColor),
                                ),
                              ),
                              expanded: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        controller.toggle();
                                        annotationBloc.updateSortList(
                                            SortListing.CreatedAt);
                                      },
                                      child: _chipingSort(
                                          Translations.current
                                              .text('sort_type_1'),
                                          SortListing.CreatedAt)),
                                  FlatButton(
                                      onPressed: () {
                                        controller.toggle();
                                        annotationBloc.updateSortList(
                                            SortListing.ModifiedAt);
                                      },
                                      child: _chipingSort(
                                          Translations.current
                                              .text('sort_type_2'),
                                          SortListing.ModifiedAt)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              onPressed: () {
                                controller.toggle();
                              },
                              child: SvgPicture.asset(
                                controller.expanded
                                    ? 'assets/icons/cancel.svg'
                                    : 'assets/icons/sort.svg',
                                height: 24,
                                width: 24,
                                color: controller.expanded
                                    ? Colors.red[800]
                                    : Styles.iconColor,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              );
            })),
          ),
          SizedBox(
            height: 10,
          ),
          ExpandableNotifier(
            child: Container(child: Builder(builder: (context) {
              ExpandableController controller =
                  ExpandableController.of(context);
              return Column(
                children: <Widget>[
                  Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Styles.placeholderColor,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Expandable(
                              collapsed: Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Text(
                                  Translations.current.text('view_avatars'),
                                  style: Styles.styleDescription(
                                    color: Styles.titleColor,
                                    textSizeDescription: 16,
                                  ),
                                ),
                              ),
                              expanded: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        controller.toggle();
                                        annotationBloc.updateAvatarMode(
                                            LetterType.Circular);
                                      },
                                      child: _chipingLeeter(
                                          Translations.current
                                              .text('avatar_type_1'),
                                          LetterType.Circular)),
                                  FlatButton(
                                      onPressed: () {
                                        controller.toggle();
                                        annotationBloc.updateAvatarMode(
                                            LetterType.Rectangle);
                                      },
                                      child: _chipingLeeter(
                                          Translations.current
                                              .text('avatar_type_2'),
                                          LetterType.Rectangle)),
                                  FlatButton(
                                      onPressed: () async {
                                        controller.toggle();
                                        annotationBloc
                                            .updateAvatarMode(LetterType.None);
                                      },
                                      child: _chipingLeeter(
                                          Translations.current
                                              .text('avatar_type_3'),
                                          LetterType.None))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              onPressed: () {
                                controller.toggle();
                              },
                              child: SvgPicture.asset(
                                controller.expanded
                                    ? 'assets/icons/cancel.svg'
                                    : 'assets/icons/eye.svg',
                                height: 24,
                                width: 24,
                                color: controller.expanded
                                    ? Colors.red[800]
                                    : Styles.iconColor,
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              );
            })),
          ),
          SizedBox(
            height: 10,
          ),
          Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Styles.placeholderColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      themeBloc.themeType == ThemeType.Light
                          ? Translations.current.text('mode_dark_true')
                          : Translations.current.text('mode_dark_false'),
                      style: Styles.styleDescription(
                        color: Styles.titleColor,
                        textSizeDescription: 16,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 16.0),
                  ),
                  Switch(
                      value:
                          themeBloc.themeType == ThemeType.Light ? false : true,
                      onChanged: (bool value) {
                        themeBloc
                            .dispatch(ConfigChangeTheme(value ? ThemeType.Dark : ThemeType.Light));
                      }),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              annotationBloc.changeLanguageDialog(context,this);
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Styles.placeholderColor,
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: Text(Translations.current.text('language'),
                      style: Styles.styleDescription(
                        color: Styles.titleColor,
                        textSizeDescription: 16,
                      ))),
            ),
          )
        ],
      ),
    );
  }

  _home() {
    return Scaffold(
      body: BlocBuilder<AnnotationBloc, ObjectState>(
        builder: (context, objectState) {
          if (objectState is ObjectError) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text(
                    Translations.current
                        .text('message_error_loading_annotation'),
                    style: Styles.styleDescription(color: Styles.subtitleColor),
                  ),
                  FlatButton(
                      onPressed: () {
                        annotationBloc.dispatch(Run());
                      },
                      child: Text(
                        Translations.current.text('update'),
                        style:
                            Styles.styleDescription(color: Styles.titleColor),
                      ))
                ],
              ),
            );
          }
          if (objectState is ObjectLoaded) {
            var objectLoaded = (objectState as ObjectLoaded);
            if (objectState.objects.isEmpty) {
              return Center(
                child: Text(
                  Translations.current.text('no_notes_found'),
                  style: Styles.styleDescription(color: Styles.subtitleColor),
                ),
              );
            }
            return ListView.builder(
                itemCount: objectLoaded.objects.length,
                itemBuilder: (context, index) {
                  var anotation = (objectLoaded.objects[index] as Annotation);
                  return AnnotationItemUi(
                    key: Key(anotation.title),
                    position: index,
                    anotation: anotation,
                    actionMoreListener: this,
                    onTap: () {
                      Navigator.pushNamed(context, '/openAnnotation',
                          arguments: anotation);
                    },
                  );
                });
          }

          return progressWidget();
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: SvgPicture.asset(
                'assets/icons/add.svg',
                height: 24,
                width: 24,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/newAnotation');
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deleteAnnotation(int position) {
    annotationBloc.deleteItemDialog(position, context);
  }

  @override
  void infoAnnotation(int position) {
    annotationBloc.detailItem(position, context);
  }

  @override
  void openAnnotation(int position) {
    var annotation =
        (annotationBloc.currentState as ObjectLoaded).objects[position];
    Navigator.pushNamed(context, '/openAnnotation', arguments: annotation);
  }

  @override
  onChangeLanguage(Locale locale) {
    themeBloc.dispatch(ConfigChangeLanguage(locale));
  }
}
