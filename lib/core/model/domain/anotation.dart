

import '../../../utils/constants.dart';
import 'content.dart';
abstract class AnnotationColumn{
  static const TITLE = 'title';
  static const COLOR = 'color';
  static const CREATED_AT = 'createdAt';
  static const MODIFIED_AT = 'modifiedAt';
}
class Annotation {
  final int id_anotation;
  String title;
  bool expanded;
  List<Content> contents;
  String color;
  final DateTime createdAt;

  DateTime modifiedAt;

  getNumContents() {
    if(contents == null){
      contents = List<Content>();
    }
    return contents.length;
  }

  setContents(List<Content> list) {
    this.contents = list;
  }

  List <Content> contentList() {
    return contents;
  }
  setTitle(String title) {
    this.title = title;
  }

//
  setColor(String color) {
    this.color = color;
  }

  setexpanded(bool value) {
    this.expanded = value;
  }

//
  setModifiedAt(DateTime modifiedAt) {
    this.modifiedAt = modifiedAt;
  }

  Annotation(
      {this.id_anotation = 0,
      this.title = '',
      this.color = COLOR_DEFAULT,
      this.createdAt,
      this.modifiedAt}) {
    expanded = false;
  }

  Annotation.fromJsonMap(Map<String, dynamic> map)
      : id_anotation = map['id_anotation'],
        title = map['title'],
        color = map['color'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        modifiedAt = DateTime.fromMillisecondsSinceEpoch(map['modifiedAt']);

  Map<String, dynamic> toMap() => {
        'id_anotation': id_anotation,
        'title': title,
        'color': color,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'modifiedAt': modifiedAt.millisecondsSinceEpoch
      };
}
