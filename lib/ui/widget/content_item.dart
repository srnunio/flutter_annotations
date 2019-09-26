
import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/listeners/actions.dart';
import 'package:flutter_annotations/core/model/domain/content.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_annotations/utils/utils.dart';
import 'package:flutter_svg/svg.dart';

class ContentItem extends StatelessWidget{
  final Content content;
  final int index;
  final String color;
  final ContentMoreListener contentMoreListener;

  ContentItem({this.contentMoreListener,this.content,this.index,this.color});

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
                            color: content.id_anotation > 0
                                ? colorParse(hexCode: color)
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
    return GestureDetector(
      child:  Container(
          margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0),

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
                            if(contentMoreListener != null){
                              contentMoreListener.deleteContent(index);
                            }
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

                            if(contentMoreListener != null){
                              contentMoreListener.sharedContent(index);
                            }

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
          })),
      onLongPress: (){
       if(contentMoreListener != null){
         contentMoreListener.copyValueContent(index);
       }
      },
    );
  }

}