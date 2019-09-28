
import 'package:flutter/material.dart';
import 'package:flutter_annotations/ui/view/list_annotations_page.dart';
import 'package:flutter_annotations/ui/view/create_annotation_page.dart';
import 'package:flutter_annotations/ui/view/search_annotations_page.dart';
import '../core/model/domain/anotation.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ListAnnotationPage());
//        return MaterialPageRoute(builder: (_) => CreatedAnnotationPage());
      case '/newAnotation':

        return MaterialPageRoute(builder: (_) => CreatedAnnotationPage());
      case '/openAnnotation':
        var annotation = settings.arguments as Annotation;
        return MaterialPageRoute(builder: (_) => CreatedAnnotationPage(anotation: annotation,));
      case '/searchPage':
        return MaterialPageRoute(builder: (_) => SearchAnnotationPage());
      default:
        return MaterialPageRoute(builder: (_) => ListAnnotationPage());
    }
  }
}
