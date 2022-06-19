part of core.types;

class ToastData {
  final String title;
  final String description;
  final LogType logType;
  bool hasBeenShown = false;
  // final SemanticButtonData positiveAction;
  // final SemanticButtonData negativeAction;
  // final SemanticButtonData neutralAction;

  ToastData({
    required this.title,
    required this.description,
    required this.logType,
  });
}
