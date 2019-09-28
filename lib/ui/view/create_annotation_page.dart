import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_annotations/core/bloc/annotation_bloc.dart';
import 'package:flutter_annotations/core/bloc/content_bloc.dart';
import 'package:flutter_annotations/core/bloc/object_event.dart';
import 'package:flutter_annotations/core/bloc/object_state.dart';
import 'package:flutter_annotations/core/listeners/actions.dart';
import 'package:flutter_annotations/core/model/domain/anotation.dart';
import 'package:flutter_annotations/core/model/domain/content.dart';
import 'package:flutter_annotations/ui/view/list_annotations_page.dart';
import 'package:flutter_annotations/ui/widget/content_item.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_annotations/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

class CreatedAnnotationPage extends StatelessWidget {
  Annotation _anotation;

  CreatedAnnotationPage(
      {Annotation anotation = null, BuildContext buildContext}) {
    if (anotation == null) {
      this._anotation = Annotation();
    } else {
      this._anotation = anotation;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiBlocProvider(providers: [
//      BlocProvider<AnnotationBloc>(
//        builder: (BuildContext context) => AnnotationBloc(),
//      ),
      BlocProvider<ContentAnnotationBloc>(
        builder: (BuildContext context) => ContentAnnotationBloc(_anotation),
      ),
    ], child: CreatedAnnotationView(_anotation));
  }
}

class CreatedAnnotationView extends StatefulWidget {
  final Annotation _anotation;

  CreatedAnnotationView(this._anotation);

  @override
  _CreatedAnnotationView createState() => _CreatedAnnotationView(_anotation);
}

class _CreatedAnnotationView extends State<CreatedAnnotationView>
    implements ContentMoreListener {
  final Annotation _anotation;
  String value;
  bool isValues = false;
  final TextEditingController _textEditingController = TextEditingController();
  ContentAnnotationBloc _contentAnnotationBloc;

//  AnnotationBloc _annotationBloc;

  _CreatedAnnotationView(this._anotation);

  @override
  void initState() {
    super.initState();
    _contentAnnotationBloc = BlocProvider.of<ContentAnnotationBloc>(context);
//    _annotationBloc = BlocProvider.of<AnnotationBloc>(context);
    _contentAnnotationBloc..dispatch(Run());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _home(),
      ),
    );
  }

  _buildSetting() {
    return <Widget>[
      IconButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          _contentAnnotationBloc.settingsDialog(context);
        },
        icon: SvgPicture.asset(
          'assets/icons/sliders.svg',
          height: 24,
          width: 24,
          color: Styles.iconColor,
        ),
      ),
    ];
  }

  _buidSave() {
    return <Widget>[
      IconButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () async {
          var result =
              await _contentAnnotationBloc.saveAnnotationDialog(context);
          if (result) {
            annotationBloc.dispatch(Run());
          }
        },
        icon: SvgPicture.asset(
          'assets/icons/save.svg',
          height: 24,
          width: 24,
          color: Styles.iconColor,
        ),
      ),
    ];
  }

  _home() {
    return Scaffold(
      bottomNavigationBar: _buildEditor(),
      appBar: AppBar(
          iconTheme: IconThemeData(color: Styles.iconColor),
          elevation: 0,
          title: Text(
            _contentAnnotationBloc.annottation.id_anotation > 0
                ? _contentAnnotationBloc.annottation.title
                : Translations.current.text('new_annotation'),
            style: Styles.styleTitle(color: Styles.titleColor),
          ),
          actions: _contentAnnotationBloc.annottation.id_anotation > 0
              ? _buildSetting()
              : _buidSave()),
      body: BlocBuilder<ContentAnnotationBloc, ObjectState>(
        builder: (context, objectState) {
          if (objectState is ObjectError) {
            return Center(
              child: Text(
                Translations.current.text('no_content'),
                style: Styles.styleDescription(color: Styles.subtitleColor),
              ),
            );
          }
          if (objectState is ObjectLoaded) {
            var objectLoaded = (objectState as ObjectLoaded);
            if (objectState.objects.isEmpty) {
              return Center(
                child: Text(
                  Translations.current.text('no_content'),
                  style: Styles.styleDescription(color: Styles.subtitleColor),
                ),
              );
            }
            return ListView.builder(
                itemCount: objectLoaded.objects.length,
                itemBuilder: (context, index) {
                  var content = (objectLoaded.objects[index] as Content);
                  return ContentItem(
                    contentMoreListener: this,
                    content: content,
                    index: index,
                    color: _contentAnnotationBloc.annottation.color,
                  );
                });
          }
          return progressWidget();
        },
      ),
    );
  }

  Widget _buildEditor() {
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
              icon: SvgPicture.asset(
                'assets/icons/cancel.svg',
                height: 24,
                width: 24,
                color: isValues ? Styles.iconColor : Styles.backgroundColor,
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
                _textEditingController.clear();
                setState(() {
                  isValues = false;
                });
              },
            ),
          ),
          IconButton(
              icon: SvgPicture.asset(
                'assets/icons/check.svg',
                height: 24,
                width: 24,
                color: isValues ? Styles.iconColor : Styles.backgroundColor,
              ),
              onPressed: isValues
                  ? () async {
                      var result =
                          await _contentAnnotationBloc.insertContent(value);
                      _textEditingController.clear();
                      value = "";
                      setState(() {
                        isValues = false;
                      });
                      if (result) {
                        annotationBloc.dispatch(Run());
                      }
                    }
                  : null)
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void copyValueContent(int position) {
    try {
      var content = (_contentAnnotationBloc.currentState as ObjectLoaded)
          .objects[position] as Content;
      Clipboard.setData(ClipboardData(text: content.value));
      messageToas(message: Translations.current.text('copy_test'));
    } catch (_) {}
  }

  @override
  void deleteContent(int position) {
    _contentAnnotationBloc.deleteItemDialog(position, context);
  }

  @override
  void sharedContent(int position) {
    var content = (_contentAnnotationBloc.currentState as ObjectLoaded)
        .objects[position] as Content;
    final RenderBox box = context.findRenderObject();
    Share.share(content.value,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
