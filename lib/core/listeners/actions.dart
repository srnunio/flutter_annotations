abstract class AnnotationMoreListener {
  void openAnnotation(int position);
  void infoAnnotation(int position);
  void deleteAnnotation(int position);
}

abstract class ContentMoreListener {
  void sharedContent(int position);
  void copyValueContent(int position);
  void deleteContent(int position);
}