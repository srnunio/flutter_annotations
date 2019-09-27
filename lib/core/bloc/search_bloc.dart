import 'package:flutter_annotations/core/model/domain/anotation.dart';
import 'package:flutter_annotations/utils/constants.dart';

import 'bloc_base.dart';
import 'object_event.dart';
import 'object_state.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends AnnotationBase {
  String _valueQuery = null;

  @override
  get initialState => ObjectUninitialized();

  void updateQueryValue(String valueQuery) {
    this._valueQuery = valueQuery;

    dispatch(Run());
  }

  Future<List<Annotation>> _search() async {
    var searchs = List<Annotation>();

    if (_valueQuery == null || _valueQuery.length == 0) return searchs;

    var query =
        'select * from $DB_ANOTATION_TABLE_NAME where title like ${"'%$_valueQuery%'"}';
    print('query = ${query}');
    List<Map> jsons = await this.database.rawQuery(query);
    searchs = jsons.map((json) => Annotation.fromJsonMap(json)).toList();

    return searchs;
  }

  Stream<ObjectState> transformEvents(Stream<ObjectEvent> events,
      Stream<ObjectState> Function(ObjectEvent event) next) {
    return super.transformEvents(
        (events as Observable<ObjectEvent>)
            .debounceTime(Duration(milliseconds: 500)),
        next);
  }

  @override
  Stream<ObjectState> mapEventToState(ObjectEvent event) async* {
    if (event is Run) {
      try {
        if (currentState is ObjectUninitialized) {
          var annotations = await _search();
          yield ObjectLoaded(objects: annotations, hasReachedMax: false);
          return;
        }
        if (currentState is ObjectLoaded) {
          var annotations = await _search();
          yield annotations.isEmpty
              ? (currentState as ObjectLoaded).copyWith(hasReachedMax: true)
              : ObjectLoaded(objects: annotations, hasReachedMax: false);
        }
      } catch (_) {
        yield ObjectError();
      }
    }
  }

  SearchBloc() : super();
}
