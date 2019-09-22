import 'dart:math';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/ui/widget/content_item.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

import '../../core/model/domain/anotation.dart';
import '../../core/model/domain/content.dart';
import '../../core/model/enums/view_state.dart';
import '../../utils/Translations.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../viewmodel/content_model.dart';
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
          valueColor: AlwaysStoppedAnimation<Color>(Styles.progressColor),
        ),
      ),
    );
  }

  Widget _listDatas(ContentModel model) {
    return ListView.builder(
        itemCount: model.contents.length,
        itemBuilder: (BuildContext c, int i) {
          var content = model.contents[i];
          return ContentItem(
            content: content,
            index: i,
          );
        });
  }

  Widget _editor(ContentModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Styles.placeholderColor,
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
                color: isValues ? Styles.iconColor : null,
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
        onStartModel: (model) {
          model.init(anotation, context);
        },
        builder: (context, model, child) => Scaffold(
              body: Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Styles.titleColor),
                  elevation: 0,
                  title: Text(
                    model.anotation.id_anotation > 0
                        ? model.anotation.title
                        : Translations.current.text('new_annotation'),
                    style: Styles.styleTitle(color: Styles.titleColor),
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
                              color: Styles.titleColor,
                            ),
                          )
                  ],
                ),
//                backgroundColor: Styles.backgroundColor,
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
