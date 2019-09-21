import 'package:anotacoes/core/data/preferences.dart';
import 'package:anotacoes/core/model/domain/anotation.dart';
import 'package:anotacoes/core/model/enums/view_state.dart';
import 'package:anotacoes/ui/listeners/actions.dart';
import 'package:anotacoes/ui/view/base_view.dart';
import 'package:anotacoes/ui/widget/anotation_widget.dart';
import 'package:anotacoes/utils/Translations.dart';
import 'package:anotacoes/utils/constants.dart';
import 'package:anotacoes/utils/styles.dart';
import 'package:anotacoes/utils/utils.dart';
import 'package:anotacoes/viewmodel/anotation_model.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:backdrop/backdrop.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnotetionView extends StatelessWidget implements ActionMoreListener {
  AnotationModel _model;

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
      margin: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
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
                      color: Colors.grey[200],
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
                                      color:
                                      colorParse(hexCode: COLOR_DEFAULT)),
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
                                        _model.updateSortList(
                                            SortListing.CreatedAt);
                                      },
                                      child: _chipingSort(
                                          Translations.current
                                              .text('sort_type_1'),
                                          SortListing.CreatedAt)),
                                  FlatButton(
                                      onPressed: () {
                                        controller.toggle();
                                        _model.updateSortList(
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
                                    : colorParse(hexCode: COLOR_DEFAULT),
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
                      color: Colors.grey[200],
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
                                    color: colorParse(hexCode: COLOR_DEFAULT),
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
                                        _model.updateAvatarMode(
                                            LetterType.Circular);
                                      },
                                      child: _chipingLeeter(
                                          Translations.current
                                              .text('avatar_type_1'),
                                          LetterType.Circular)),
                                  FlatButton(
                                      onPressed: () {
                                        controller.toggle();
                                        _model.updateAvatarMode(
                                            LetterType.Rectangle);
                                      },
                                      child: _chipingLeeter(
                                          Translations.current
                                              .text('avatar_type_2'),
                                          LetterType.Rectangle)),
                                  FlatButton(
                                      onPressed: () async {
                                        controller.toggle();
                                        await _model
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
                                    : colorParse(hexCode: COLOR_DEFAULT),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              );
            })),
          )
        ],
      ),
    );
  }

  Widget view(AnotationModel model, BuildContext context) {
    switch (model.state) {
      case ViewState.Refresh:
        return anotationsUi(model);
      case ViewState.Idle:
        return anotationsUi(model);
      case ViewState.Busy:
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                colorParse(hexCode: COLOR_DEFAULT)),
          ),
        );
      case ViewState.Empty:
        return Center(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Translations.current.text('no_notes_found'),
                  style: Styles.styleDescription(color: Colors.black),
                )
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AnotationModel>(
      onModelChanged: (model) {
        print('onModelChanged => ${model.actived()}');
        if (!model.actived()) {
          model.read_items();
        }
      },
      onModelPaused: (model) => model.setActived(false),
      onModelReady: (model) {
        _model = model;
        model.init(context);
      },
      builder: (context, model, child) {
        _model = model;
        _model.setContext(context);
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
              ),
            ),
          ],
          title: Text(
            Translations.current.text('annotations'),
            textAlign: TextAlign.center,
            style: Styles.styleTitle(color: colorParse(hexCode: COLOR_DEFAULT)),
          ),
          headerHeight: 600.0,
          backLayer: Container(
            child: Center(
                child:_buildMores(),),
          ),
          frontLayer: Scaffold(
            body: SafeArea(
              child: Scaffold(
                body: view(model, context),
              ),
            ),
            floatingActionButton: _builFloating(context),
          ),
          iconPosition: BackdropIconPosition.leading,
        );
      },
    );
  }

  _newAnotation(BuildContext context) {
    Anotation anotation = Anotation();
    Navigator.pushNamed(context, '/newAnotation', arguments: anotation);
  }

  FloatingActionButton _builFloating(BuildContext context) {
    return FloatingActionButton(
      child: SvgPicture.asset(
        'assets/icons/add.svg',
        height: 24,
        width: 24,
        color: Colors.white,
      ),
      backgroundColor: colorParse(hexCode: COLOR_DEFAULT),
      onPressed: () {
        _newAnotation(context);
      },
    );
  }

  Widget anotationsUi(AnotationModel model) {
    return Container(
        margin: EdgeInsets.only(top: 8.0),
        child: ListView.builder(
            itemCount: model.anotations.length,
            itemBuilder: (context, index) {
              var anotation = model.anotations[index];
              return AnnotationItemUi(
                key: Key(anotation.title),
                position: index,
                actionMoreListener: this,
                anotation: anotation,
                onTap: () {
                  open(index);
                },
              );
            }));
  }

  @override
  void deleteAnnotation(int position) {
    print('deleteAnnotation:position ${position}');
    _model.deleteItem(position);
  }

  @override
  void infoAnnotation(int position) {
    _model.detailItem(position);
  }

  @override
  void openAnnotation(int position) {
    open(position);
  }

  void open(int position) {
    Navigator.pushNamed(_model.context(), '/newAnotation',
        arguments: _model.anotations[position]);
  }
}
