class Content {
  final int id;
  final String value;
  final DateTime createdAt;
  final DateTime modifiedAt;
     int id_anotation;




  Content({this.id, this.value,this.createdAt, this.modifiedAt,this.id_anotation = -1});


  Content.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'],
        value = map['value'],
        id_anotation = map['id_anotation'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        modifiedAt = DateTime.fromMillisecondsSinceEpoch(map['modifiedAt']);

  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'value': value,
        'id_anotation': id_anotation,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'modifiedAt': modifiedAt.millisecondsSinceEpoch
      };
}
