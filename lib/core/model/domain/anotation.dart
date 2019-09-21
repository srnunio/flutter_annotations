import 'package:anotacoes/utils/constants.dart';

import 'content.dart';

class Anotation {
  final int id_anotation;
  String title;
  bool expanded;
  List<Content> contents;
  final String description;
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

  Anotation(
      {this.id_anotation = 0,
      this.title = '',
      this.description = '',
      this.color = COLOR_DEFAULT,
      this.createdAt,
      this.modifiedAt}) {
    expanded = false;
  }

  Anotation.fromJsonMap(Map<String, dynamic> map)
      : id_anotation = map['id_anotation'],
        title = map['title'],
        description = map['description'],
        color = map['color'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        modifiedAt = DateTime.fromMillisecondsSinceEpoch(map['modifiedAt']);

  Map<String, dynamic> toMap() => {
        'id_anotation': id_anotation,
        'description': description,
        'title': title,
        'color': color,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'modifiedAt': modifiedAt.millisecondsSinceEpoch
      };
}
