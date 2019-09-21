import 'dart:math';

import 'package:anotacoes/core/model/domain/anotation.dart';
import 'package:anotacoes/core/model/domain/content.dart';
import 'package:anotacoes/core/model/enums/view_state.dart';
import 'package:anotacoes/utils/Translations.dart';
import 'package:anotacoes/utils/constants.dart';
import 'package:anotacoes/utils/styles.dart';
import 'package:anotacoes/utils/utils.dart';
import 'package:anotacoes/viewmodel/anotation_model.dart';
import 'package:anotacoes/viewmodel/content_model.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

import 'base_view.dart';

class NewAnotation extends StatefulWidget {
  final Anotation anotation;

  NewAnotation(this.anotation);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewAnotation(anotation: anotation);
  }
}

class _NewAnotation extends State<NewAnotation> {
  Color appBackgroud;
  double topPosition;
  String value;
  Anotation anotation;

  _NewAnotation({this.anotation});

  Widget _noDatas() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          Translations.current.text('no_content'),
          style: Styles.styleDescription(),
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(colorParse(hexCode: COLOR_DEFAULT)),
        ),
      ),
    );
  }

  _ItemContent(Content content) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${weekday(content.modifiedAt)} - ${formatHora('${content.modifiedAt}')}',
                    style: Styles.styleDescription(
                        color: anotation.id_anotation > 0
                            ? colorParse(hexCode: anotation.color)
                            : Colors.black),
                  ),

                ],
              ),
            )
          ],
        )),
      ],
    );
  }

  Widget _listDatas(ContentModel model) {
    return ListView.builder(
        itemCount: model.contents.length,
        itemBuilder: (BuildContext c, int i) {
          var content = model.contents[i];
          return Container(
            margin: EdgeInsets.all(16.0),

              decoration: BoxDecoration(color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5)),
              child: Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: _ItemContent(content),
                        ),
                        Expanded(
                          child: FlatButton(
                              child: SvgPicture.asset(
                                'assets/icons/delete.svg',
                                height: 18,
                                width: 18,
                                color: colorParse(hexCode: COLOR_DEFAULT),
                              ),
                              onPressed: () {
                                model.deleteItem(i);
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
                                Share.share(content.value,
                                    sharePositionOrigin:
                                        box.localToGlobal(Offset.zero) &
                                            box.size);
                              }),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child:   Text(
                        content.value,
                        style: Styles.styleDescription(
                            color: Colors.black, textSizeDescription: 18),
                      ),
                    ),

                  ],
                );
              }));
        });
  }

  Widget _editor(ContentModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.clear,
                color: isValues ? Colors.red : null,
              ),
              onPressed: isValues
                  ? () {
                      _textEditingController.clear();
                      setState(() {
                        isValues = false;
                      });
                    }
                  : null),
          Flexible(
            child: TextField(
              keyboardAppearance: Brightness.light,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  counterStyle: Styles.styleDescription(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: Translations.current.text('write_something')),
              controller: _textEditingController,
              onChanged: (String text) {
                setState(() {
                  value = text;
                  isValues = text.length > 0;
                });
              },
              onSubmitted: (String text) {
                model.addContent(text);
                _textEditingController.clear();
                setState(() {
                  isValues = false;
                });
              },
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.done,
                color: isValues ? colorParse(hexCode: COLOR_DEFAULT) : null,
              ),
              onPressed: isValues
                  ? () {
                      model.addContent(value);
                      _textEditingController.clear();
                      value = "";
                      setState(() {
                        isValues = false;
                      });
                    }
                  : null)
        ],
      )),
    );
  }

  Widget home() {
    return BaseView<ContentModel>(
        onModelReady: (model) {
          model.init(anotation, context);
        },
        builder: (context, model, child) => Scaffold(
              body: Scaffold(
                appBar: AppBar(
                  iconTheme:
                      IconThemeData(color: colorParse(hexCode: COLOR_DEFAULT)),
                  elevation: 0,
                  title: Text(
                    model.anotation.id_anotation > 0
                        ? model.anotation.title
                        : Translations.current.text('new_annotation'),
                    style: Styles.styleTitle(
                        color: colorParse(hexCode: COLOR_DEFAULT)),
                  ),
                  actions: <Widget>[
                    model.anotation.id_anotation > 0
                        ? SizedBox()
                        : FlatButton(
                            onPressed: () {
                              model.save_anotation(context);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/save.svg',
                              height: 24,
                              width: 24,
                              color: colorParse(hexCode: COLOR_DEFAULT),
                            ),
                          )
                  ],
                ),
                backgroundColor: Styles.backgroundColor,
                bottomNavigationBar: _editor(model),
                body: SafeArea(
                  child: model.state == ViewState.Busy
                      ? _loading()
                      : model.state == ViewState.Idle
                          ? _listDatas(model)
                          : _noDatas(),
                ),
              ),
            ));
  }

  @override
  void initState() {
    appBackgroud = Colors.transparent;
    super.initState();
  }

  bool isValues = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return home();
  }
}
