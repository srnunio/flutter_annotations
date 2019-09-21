
import 'package:avatar_letter/avatar_letter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/data/preferences.dart';
import '../../core/model/domain/anotation.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../listeners/actions.dart';

class AnnotationDetail extends StatelessWidget {
  Anotation _anotation;

  AnnotationDetail({Anotation anotation}) {
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
            color: Colors.white,
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
                      'Detalhes',
                      style: Styles.styleTitle(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Titulo: ',
                          style: Styles.styleDescription(
                              color: colorParse(hexCode:_anotation.color)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _anotation.title,
                          style: Styles.styleDescription(color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Data de criacao : ',
                          style: Styles.styleDescription(
                              color: colorParse(hexCode:_anotation.color)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${formatDate('${_anotation.createdAt}')}- ${weekday(_anotation.createdAt)}',
                          style: Styles.styleDescription(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Ultima actualizacao: ',
                          style: Styles.styleDescription(
                              color: colorParse(hexCode:_anotation.color)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${formatDate('${_anotation.modifiedAt}')} - ${weekday(_anotation.modifiedAt)}',
                          style: Styles.styleDescription(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Numero de conteudos',
                          style: Styles.styleDescription(
                              color: colorParse(hexCode:_anotation.color)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${_anotation.getNumContents()}',
                          style: Styles.styleDescription(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: colorParse(hexCode:COLOR_DEFAULT),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: Styles.styleTitle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ASearchItem extends StatelessWidget {
  Anotation _anotation;
  Function _onTap;

  ASearchItem({Key key, Anotation anotation, Function onTap})
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
            style: Styles.styleTitle(color: Colors.black),
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
  Anotation _anotation;
  ExpandableController controller;
  Function _onTap;
  ActionMoreListener _actionMoreListener;
  ActionMoreListener _actionMoreListenerAux;
  int position;

  AnnotationItemUi(
      {Key key,
      int position,
      ActionMoreListener actionMoreListener,
      Anotation anotation,
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
        _anotation.contents[0].value,
        maxLines: 2,
      );
    }
    return Center();
  }

  _ItemCollapsed() {
    print('AnnotationItemUi:ItemCollapsed ${Tools.letterType}');
    return
      Column(
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
                      color: colorParse(hexCode:_anotation.color),
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
                            color: colorParse(hexCode:_anotation.color),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          AvatarLetter(
                            letterType: Tools.letterType,
                            text:  letter(value: _anotation.title),
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
                          Text( '${_anotation.title}',
                            style: Styles.styleTitle(
                                color: Colors.black,
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
            color: colorParse(hexCode:_anotation.color),
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
            color: colorParse(hexCode:_anotation.color),
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
            color: colorParse(hexCode:_anotation.color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ExpandableNotifier(
        child: Container(
            padding: const EdgeInsets.only(left: 16, right: 10, bottom: 10),
            child: Builder(builder: (context) {
              controller = ExpandableController.of(context);
              return Material(
                elevation: controller.expanded ? 3.0 : 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white,
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
                          color: controller.expanded ? Colors.red[800] : null,
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

//class AnnotationItemUi extends StatelessWidget {
//  Anotation _anotation;
//  ExpandableController controller;
//  Function _onTap;
//  ActionMoreListener _actionMoreListener;
//  ActionMoreListener _actionMoreListenerAux;
//  int position;
//
//  AnnotationItemUi(
//      {Key key,
//      int position,
//      ActionMoreListener actionMoreListener,
//      Anotation anotation,
//      Function onTap})
//      : super(key: key) {
//    this._anotation = anotation;
//    this._onTap = onTap;
//    this.position = position;
//    this._actionMoreListenerAux = actionMoreListener;
//  }
//
//  _Text(){
//    if(_anotation.getNumContents() > 0){
//      return Text(_anotation.contents[0].value,
//        maxLines: 2,
//      );
//    }
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      mainAxisSize: MainAxisSize.max,
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: <Widget>[
//        Text('${weekday(_anotation.modifiedAt)}', style: Styles.styleDescription(color: Colors.black),),
//        Text('${formatHora('${_anotation.modifiedAt}')}', style: Styles.styleDescription(color: Colors.black),),
//        Text('${_anotation.getNumContents()} ${Translations.current.text('items')}', style: Styles.styleDescription(color: Colors.black),),
//      ],
//    );
//  }
//
//  _ItemCollapsed() {
//    print('AnnotationItemUi:ItemCollapsed ${Tools.letterType}');
//    return Container(
//      child: Row(
//        mainAxisSize: MainAxisSize.max,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          LetterAvatar(
//            letterType: Tools.letterType,
//            text: letter(value: _anotation.title),
//            fontSize: 30.0,
//            fontWeight: FontWeight.w600,
//            upperCase: true,
//            size: 60.0,
//            number: 2,
//            colorBackgroundHex: _anotation.color,
//          ),
//          SizedBox(
//            width: 10,
//          ),
//          Column(
//            mainAxisSize: MainAxisSize.min,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.only(right: 16.0),
//                child: Text(
//                  '${_anotation.title}',
//                  style: Styles.styleTitle(color: Colors.black),
//                ),
//              ),
//              _Text()
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//
//  _ItemBuildExpanded() {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        Container(
//          padding: EdgeInsets.all(8.0),
//          child: LetterAvatar(
//            letterType: Tools.letterType,
//            text:  letter(value: _anotation.title),
//            fontSize: 16.0,
//            fontWeight: FontWeight.bold,
//            upperCase: true,
//            size: 40.0,
//            number: 2,
//            colorBackgroundHex: _anotation.color,
//          ),
//        ),
//        FlatButton(
//          onPressed: () {
//            if (_actionMoreListener == null) {
//              return;
//            }
//            _actionMoreListener.openAnnotation(position);
//          },
//          child: SvgPicture.asset(
//            'assets/icons/edit.svg',
//            height: 24,
//            width: 24,
//            color: parseColor(COLOR_DEFAULT),
//          ),
//        ),
//        FlatButton(
//          onPressed: () {
//            if (_actionMoreListener == null) {
//              return;
//            }
//            _actionMoreListener.infoAnnotation(position);
//          },
//          child: SvgPicture.asset(
//            'assets/icons/detail.svg',
//            height: 24,
//            width: 24,
//            color: parseColor(COLOR_DEFAULT),
//          ),
//        ),
//        FlatButton(
//          onPressed: () {
//            if (_actionMoreListener == null) {
//              return;
//            }
//            _actionMoreListener.deleteAnnotation(position);
//          },
//          child: SvgPicture.asset(
//            'assets/icons/delete.svg',
//            height: 24,
//            width: 24,
//            color: parseColor(COLOR_DEFAULT),
//          ),
//        ),
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: _onTap,
//      child:
//      ExpandableNotifier(
//        child: Container(
//            padding: const EdgeInsets.only(left: 16, right: 10, bottom: 10),
//            child: Builder(builder: (context) {
//              controller = ExpandableController.of(context);
//              return Material(
//                elevation: controller.expanded ? 3.0 : 0.0,
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                ),
//                color: Colors.white,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  mainAxisSize: MainAxisSize.max,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                        flex: 6,
//                        child: Expandable(
//                          key: Key('${_anotation.id_anotation}'),
//                          collapsed: _ItemCollapsed(),
//                          expanded: _ItemBuildExpanded(),
//                        )),
//                    Expanded(
//                      child: FlatButton(
//                        onPressed: () {
//                          controller.toggle();
//                          if (controller.expanded) {
//                            _actionMoreListener = _actionMoreListenerAux;
//                          } else {
//                            _actionMoreListener = null;
//                          }
//                        },
//                        child: SvgPicture.asset(
//                          controller.expanded
//                              ? 'assets/icons/cancel.svg'
//                              : 'assets/icons/more.svg',
//                          height: 24,
//                          width: 24,
//                          color: controller.expanded ? Colors.red[800] : null,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              );
//            })),
//      ),
//    );
//  }
//}
