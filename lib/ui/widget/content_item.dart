import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/model/domain/content.dart';
import 'package:flutter_annotations/locator.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_annotations/utils/utils.dart';
import 'package:flutter_annotations/viewmodel/content_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

class ContentItem extends StatelessWidget{
  final Content content;
  final int index;
  final contentModel = locator.get<ContentModel>();

  ContentItem({this.content,this.index});

  _buildContent() {
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
                        style: Styles.styleDescription(fontWeight: FontWeight.bold,
                            color: contentModel.anotation.id_anotation > 0
                                ? colorParse(hexCode: contentModel.anotation.color)
                                : Styles.titleColor),
                      ),

                    ],
                  ),
                )
              ],
            )),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(16.0),

        decoration: BoxDecoration(color: Styles.placeholderColor,
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
                    child: _buildContent(),
                  ),
                  Expanded(
                    child: FlatButton(
                        child: SvgPicture.asset(
                          'assets/icons/delete.svg',
                          height: 18,
                          width: 18,
                          color: Styles.iconColor,
                        ),
                        onPressed: () {
                          contentModel.deleteItem(index);
                        }),
                  ),
                  Expanded(
                    child: FlatButton(
                        child: SvgPicture.asset(
                          'assets/icons/send.svg',
                          height: 18,
                          width: 18,
                          color: Styles.iconColor,
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
                      color: Styles.subtitleColor, textSizeDescription: 18),
                ),
              ),

            ],
          );
        }));
  }

}