part of core.types;

/// Specifies the relation between two dependencies, say, A and B,
/// in the form: A [DependencyRelation] B.
/// If A needs to be completed for B to proceed, we can say that:
/// A [DependencyRelation.isBlockedBy] B.
enum DependencyRelation {
  isBlocking,
  isBlockedBy,
}

////////////////////
// LighthouseObjects
////////////////////

abstract class LighthouseObject {
  final JSON json;

  LighthouseObject(this.json) {
    json.putIfAbsent('revs', () => [DateTime.now().toIso8601String()]);
    json.putIfAbsent('id', () => 'NO IMPL');
  }

  List<String> get revisions => json['revs'].cast<String>();

  String get revisionId => json['revs'].last;
  set revisionId(String revId) => json['revs'] = revId;

  String get objectId => json['id'];

  /// Use this method instead of [List.add] whenever modifying a list in the [LighthouseObject].
  /// Pass the value to be added, and the [List] to add to. [bump] will automatically be called.
  void push<T>(T value, List<T> list) {
    list.add(value);
    bump();
  }

  /// Called whenever a change is made, adding the [DateTime] of the latest change
  /// to the list of [revisions]. [Learn more](github.com)
  ///
  /// The number of revisions depends on the user's configuration and their network
  /// status.
  void bump() {
    json['revs'].add(DateTime.now().toIso8601String());
    /**
     * max revisions:
     * - extra: 80
     * - default: 50
     * - lean: 30
     * - offline: no limit
     */
    if (json['revs'].length >= 50) json['revs'].removeAt(0);
  }
}

abstract class CoreObject extends LighthouseObject {
  CoreObject(JSON json) : super(json);
}

abstract class SubObject extends LighthouseObject {
  SubObject(JSON json) : super(json);
}

////////////////////
// CoreObjects
////////////////////

class Workbench extends CoreObject {
  Workbench({
    required String name,
    bool isDefault = true,
    List<String>? projects,
  }) : super({
          'name': name,
          'projects': projects ?? <String>[],
          'isDefault': isDefault,
        });
  Workbench.fromJSON(JSON json) : super(json);

  List<String> get projects => json['projects'];

  bool get isDefault => json['default'].parseBool();
}

class Goal extends CoreObject {
  Goal(JSON json) : super(json);
}

////////////////////
// SubObjects
////////////////////

class ContextConstraint extends SubObject {
  ContextConstraint(JSON json) : super(json);
}

class Anchor extends SubObject {
  Anchor(JSON json) : super(json);
}

class Schedule extends SubObject {
  Schedule(JSON json) : super(json);
}
