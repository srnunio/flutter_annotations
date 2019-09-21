class Content {
  final int id;
  final int type_content;
  final String value;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int id_anotation;



  Content({this.id, this.value, this.type_content,this.createdAt, this.modifiedAt,this.id_anotation});

  Content.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        value = map['value'],
        type_content = map['type_content'],
        id_anotation = map['id_anotation'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        modifiedAt = DateTime.fromMillisecondsSinceEpoch(map['modifiedAt']);

  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'value': value,
        'type_content': type_content,
        'id_anotation': type_content,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'modifiedAt': modifiedAt.millisecondsSinceEpoch
      };
}
