
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'core/data/preferences.dart';
import 'core/model/domain/anotation.dart';
import 'utils/constants.dart';
import 'utils/styles.dart';
import 'utils/utils.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Annotation _anotation = Annotation(
      id_anotation: 1,
      title: 'Flutter Design',
      color: '${coloRandom()}',
      modifiedAt: DateTime.now(),
      createdAt: DateTime.now());

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            height: 120,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child:
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${weekday(_anotation.modifiedAt)} ${formatHora('${_anotation.modifiedAt}')} , ${_anotation.createdAt.year}',
                        style: Styles.styleDescription(
                            color: parseColor(hexCode: _anotation.color),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Flutter Design',
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
        FlatButton(
          onPressed: () {
//            if (_actionMoreListener == null) {
//              return;
//            }
//            _actionMoreListener.openAnnotation(position);
          },
          child: SvgPicture.asset(
            'assets/icons/edit.svg',
            height: 24,
            width: 24,
            color: parseColor(hexCode: _anotation.color),
          ),
        ),
        FlatButton(
          onPressed: () {
//            if (_actionMoreListener == null) {
//              return;
//            }
//            _actionMoreListener.infoAnnotation(position);
          },
          child: SvgPicture.asset(
            'assets/icons/detail.svg',
            height: 24,
            width: 24,
            color: parseColor(hexCode: _anotation.color),
          ),
        ),
        FlatButton(
          onPressed: () {
//            if (_actionMoreListener == null) {
//              return;
//            }
//            _actionMoreListener.deleteAnnotation(position);
          },
          child: SvgPicture.asset(
            'assets/icons/delete.svg',
            height: 24,
            width: 24,
            color: parseColor(hexCode: _anotation.color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          margin: EdgeInsets.all(16.0),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 3.0,
            child: ExpandableNotifier(
              child:
              Container(child: Builder(builder: (context) {
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            flex: 6,
                            child: Expandable(
                              key: Key('${1}'),
                              collapsed: _ItemCollapsed(),
                              expanded: _ItemBuildExpanded(),
                            )),
                        Expanded(
                          child: FlatButton(
                              child: SvgPicture.asset(
                                'assets/icons/delete.svg',
                                height: 18,
                                width: 18,
                                color: colorParse(hexCode: COLOR_DEFAULT),
                              ),
                              onPressed: () {
//                                model.deleteItem(i);
                              }),
                        ),
                        Expanded(
                          child: FlatButton(
                              child: SvgPicture.asset(
                                'assets/icons/send.svg',
                                height: 18,
                                width: 18,
                                color: colorParse(hexCode: COLOR_DEFAULT),
                              ),
                              onPressed: () {
                                final RenderBox box =
                                    context.findRenderObject();
//                                Share.share(content.value,
//                                    sharePositionOrigin:
//                                        box.localToGlobal(Offset.zero) &
//                                            box.size);
                              }),
                        ),
                      ],
                    ),
                  ],
                );
              })),
            ),
          ),
        ));
  }
}
