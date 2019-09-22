
import 'package:flutter/material.dart';

import '../core/model/domain/anotation.dart';
import 'view/annotation_view.dart';
import 'view/new_annotation.dart';
import 'view/search_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
//        return MaterialPageRoute(builder: (_) => MyApp());
        return MaterialPageRoute(builder: (_) => AnotetionView());
//        return MaterialPageRoute(builder: (_) => NewAnotation(Anotation()));
      case '/newAnotation':
        var anotation = settings.arguments as Anotation;
        return MaterialPageRoute(builder: (_) => NewAnotation(anotation));
      case '/searchPage':
        return MaterialPageRoute(builder: (_) => SearchPage());
      default:
        return MaterialPageRoute(builder: (_) => AnotetionView());
    }
  }
}
