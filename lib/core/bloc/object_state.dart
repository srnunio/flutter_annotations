import 'package:equatable/equatable.dart';

abstract class ObjectState extends Equatable {
  ObjectState([List props = const []]) : super(props);
}

class ObjectError extends ObjectState {
  @override
  String toString() => 'ObjectError';
}

class ObjectRefresh extends ObjectState {
  @override
  String toString() => 'ObjectRefresh';
}

class ObjectUninitialized extends ObjectState {
  @override
  String toString() => 'ObjectUninitialized';
}

class ObjectLoaded extends ObjectState {
  final List<Object> objects;
  final bool hasReachedMax;

  ObjectLoaded({
    this.objects,
    this.hasReachedMax,
  }) : super([objects, hasReachedMax]);

  ObjectLoaded copyWith({
    List<Object> objects,
    bool hasReachedMax,
  }) {
    return ObjectLoaded(
      objects: objects ?? this.objects,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'ObjectLoaded { posts: ${objects.length}, hasReachedMax: $hasReachedMax }';
}
