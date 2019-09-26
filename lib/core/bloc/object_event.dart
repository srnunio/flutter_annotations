import 'package:equatable/equatable.dart';

abstract class ObjectEvent extends Equatable {}

class Run extends ObjectEvent {
  @override
  String toString() => 'Run';
}

class Reload extends ObjectEvent {
  @override
  String toString() => 'Reload';
}

class Refresh extends ObjectEvent {
  @override
  String toString() => 'Reload';
}



