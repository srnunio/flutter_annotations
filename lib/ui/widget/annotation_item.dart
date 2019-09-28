import 'package:avatar_letter/avatar_letter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_annotations/core/listeners/actions.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/data/preferences.dart';
import '../../core/model/domain/anotation.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';

class AnnotationDetail extends StatelessWidget {
  Annotation _anotation;

  AnnotationDetail({Annotation anotation}) {
    this._anotation = anotation;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: 270,
        decoration: BoxDecoration(
            color: Styles.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 222,
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Translations.current.text('detail'),
                      style: Styles.styleDescription(
                          textSizeDescription: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Styles.titleColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          Translations.current.text('name_annotation'),
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Styles.titleColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _anotation.title,
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              color: Styles.titleColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          Translations.current.text('sort_type_1'),
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Styles.titleColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${formatDate('${_anotation.createdAt}')}- ${weekday(_anotation.createdAt)}',
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              color: Styles.titleColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          Translations.current.text('sort_type_2'),
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Styles.titleColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${formatDate('${_anotation.modifiedAt}')} - ${weekday(_anotation.modifiedAt)}',
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              color: Styles.titleColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          Translations.current.text('items'),
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Styles.titleColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${_anotation.getNumContents()}',
                          style: Styles.styleDescription(
                              textSizeDescription: 16.0,
                              color: Styles.titleColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: Styles.styleTitle(color: Styles.titleColor),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ASearchItem extends StatelessWidget {
  Annotation _anotation;
  Function _onTap;

  ASearchItem({Key key, Annotation anotation, Function onTap})
      : super(key: key) {
    this._anotation = anotation;
    this._onTap = onTap;
  }

  _item() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AvatarLetter(
            letterType: Tools.letterType,
            text: letter(value: _anotation.title),
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            upperCase: true,
            size: 40.0,
            backgroundColorHex: _anotation.color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '${_anotation.title}',
            style: Styles.styleTitle(color: Styles.titleColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: _item(),
    );
  }
}

class AnnotationItemUi extends StatelessWidget {
  Annotation _anotation;
  ExpandableController controller;
  Function _onTap;
  AnnotationMoreListener _actionMoreListener;
  AnnotationMoreListener _actionMoreListenerAux;
  int position;


  AnnotationItemUi(
      {Key key,
      int position,
      AnnotationMoreListener actionMoreListener,
      Annotation anotation,
      Function onTap})
      : super(key: key) {
    this._anotation = anotation;
    this._onTap = onTap;
    this.position = position;
    this._actionMoreListenerAux = actionMoreListener;
  }

  _Text() {
    if (_anotation.getNumContents() > 0) {
      return Text(
        '${_anotation.contents[0].value}',
        maxLines: 2,
      );
    }
    return Center();
  }

  _ItemCollapsed() {
//    print('AnnotationItemUi:ItemCollapsed ${Tools.letterType}');
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            height: 120,
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: colorParse(hexCode: _anotation.color),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        topLeft: Radius.circular(5.0),
                      )),
                  width: 10,
                  height: 120,
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: Column(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${weekday(_anotation.modifiedAt)} ${formatHora('${_anotation.modifiedAt}')} , ${_anotation.createdAt.year}',
                        style: Styles.styleDescription(
                            color: colorParse(hexCode: _anotation.color),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          AvatarLetter(
                            letterType: Tools.letterType,
                            text: letter(value: _anotation.title),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            upperCase: true,
                            size: 40.0,
                            numberLetters: 2,
                            backgroundColorHex: _anotation.color,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${_anotation.title}',
                            maxLines: 2,
                            style: Styles.styleTitle(
                                color: Styles.titleColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _Text()
                    ],
                  ),
                )
              ],
            )),
      ],
    );
  }

  _ItemBuildExpanded() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          child: AvatarLetter(
            letterType: Tools.letterType,
            text: letter(value: _anotation.title),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            upperCase: true,
            size: 40.0,
            numberLetters: 2,
            backgroundColorHex: _anotation.color,
          ),
        ),
        FlatButton(
          onPressed: () {
            if (_actionMoreListener == null) {
              return;
            }
            _actionMoreListener.openAnnotation(position);
          },
          child: SvgPicture.asset(
            'assets/icons/edit.svg',
            height: 24,
            width: 24,
            color: colorParse(hexCode: _anotation.color),
          ),
        ),
        FlatButton(
          onPressed: () {
            if (_actionMoreListener == null) {
              return;
            }
            _actionMoreListener.infoAnnotation(position);
          },
          child: SvgPicture.asset(
            'assets/icons/detail.svg',
            height: 24,
            width: 24,
            color: colorParse(hexCode: _anotation.color),
          ),
        ),
        FlatButton(
          onPressed: () {
            if (_actionMoreListener == null) {
              return;
            }
            _actionMoreListener.deleteAnnotation(position);
          },
          child: SvgPicture.asset(
            'assets/icons/delete.svg',
            height: 24,
            width: 24,
            color: colorParse(hexCode: _anotation.color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onLongPress: (){
        Clipboard.setData(ClipboardData(text: _anotation.title));
      },
      child: ExpandableNotifier(
        child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: Builder(builder: (context) {
              controller = ExpandableController.of(context);
              return Material(
                elevation: controller.expanded ? 3.0 : 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Styles.placeholderColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 6,
                        child: Expandable(
                          key: Key('${_anotation.id_anotation}'),
                          collapsed: _ItemCollapsed(),
                          expanded: _ItemBuildExpanded(),
                        )),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          controller.toggle();
                          if (controller.expanded) {
                            _actionMoreListener = _actionMoreListenerAux;
                          } else {
                            _actionMoreListener = null;
                          }
                        },
                        child: SvgPicture.asset(
                          controller.expanded
                              ? 'assets/icons/cancel.svg'
                              : 'assets/icons/more.svg',
                          height: 24,
                          width: 24,
                          color: controller.expanded
                              ? Colors.red[800]
                              : Styles.iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }
}
