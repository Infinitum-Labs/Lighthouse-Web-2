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

  LighthouseObject(this.json, String objPrefix) {
    json.putIfAbsent('revs', () => [DateTime.now().toIso8601String()]);
    json.putIfAbsent('id', () => ObjectId.generateId(objPrefix, 'john'));
  }

  static LighthouseObject fromJSON(JSON json) {
    final String objPrefix = json['id'].split('-')[0];
    switch (objPrefix) {
      case 'wb':
        return Workbench.fromJSON(json);
      default:
        throw InvalidType(json['id'], json);
    }
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
  CoreObject(JSON json, String objPrefix) : super(json, objPrefix);
}

abstract class SubObject extends LighthouseObject {
  SubObject(JSON json, String objPrefix) : super(json, objPrefix);
}

////////////////////
// CoreObjects
////////////////////

class User extends CoreObject {
  User(JSON json) : super(json, 'u');
}

class Workbench extends CoreObject {
  Workbench({
    required String name,
    bool isDefault = true,
    List<String>? projects,
  }) : super({
          'name': name,
          'projects': projects ?? <String>[],
          'isDefault': isDefault,
        }, 'wb');
  Workbench.fromJSON(JSON json) : super(json, 'wb');

  List<String> get projects => json['projects'];

  bool get isDefault => json['default'].parseBool();
}

class Goal extends CoreObject {
  Goal(JSON json) : super(json, 'g');
}

class Project extends CoreObject {
  Project(JSON json) : super(json, 'p');

  String get name => json['name'];
  set name(String value) => json['name'] = value;

  String get description => json['description'];
  set description(String value) => json['description'] = value;

  String get creator => json['creator'];
  set creator(String value) => json['creator'] = value;

  Map<String, List<String>> get roles =>
      Map<String, List<String>>.from(json['roles']);

  List<String> get epics => List<String>.from(json['epics']);
  List<String> get tasks => List<String>.from(json['tasks']);
  List<String> get events => List<String>.from(json['events']);
}

class Epic extends CoreObject {
  Epic(JSON json) : super(json, 'e');
}

class Task extends CoreObject {
  Task(JSON json) : super(json, 't');
}

class Event extends CoreObject {
  Event(JSON json) : super(json, 'e');
}

class Document extends CoreObject {
  Document(JSON json) : super(json, 'd');
}

class Prototype extends CoreObject {
  Prototype(JSON json) : super(json, 'pt');
}

class Issue extends CoreObject {
  Issue(JSON json) : super(json, 'i');
}

class Message extends CoreObject {
  Message(JSON json) : super(json, 'm');
}

////////////////////
// SubObjects
////////////////////

class ContextConstraint extends SubObject {
  ContextConstraint(JSON json) : super(json, 'cc');
}

class Anchor extends SubObject {
  Anchor(JSON json) : super(json, 'an');
}

class Schedule extends SubObject {
  Schedule(JSON json) : super(json, 'sc');
}

/**
 * class Project extends LSObject {
  Project(Map<String, dynamic> data) : super(data);

  String get name => data['name'];
  set name(String value) => data['name'] = value;

  String get description => data['description'];
  set description(String value) => data['description'] = value;

  String get creator => data['creator'];
  set creator(String value) => data['creator'] = value;

  Map<String, List<String>> get roles => Map<String, List<String>>.from(data['roles']);

  List<String> get stickies => List<String>.from(data['stickies']);

  List<String> get epics => List<String>.from(data['epics']);

  List<String> get tasks => List<String>.from(data['tasks']);

  List<String> get events => List<String>.from(data['events']);
}

class Epic extends LSObject {
  Epic(Map<String, dynamic> data) : super(data);

  String get name => data['name'];
  set name(String value) => data['name'] = value;

  String get objective => data['objective'];
  set objective(String value) => data['objective'] = value;

  List<String> get tasks => List<String>.from(data['tasks']);

  DateTime get due => DateTime.parse(data['due']);
  set due(dynamic value) => data['due'] = value.toString();
}

class Task extends LSObject {
  Task(Map<String, dynamic> data) : super(data) {
    instances['schedule'] = Schedule(data['schedule']);
    instances['context'] = Context(data['context']);
  }

  String get name => data['name'];
  set name(String value) => data['name'] = value;

  String get notes => data['notes'];
  set notes(String value) => data['notes'] = value;

  Schedule get schedule => instances['schedule'];
  set schedule(Schedule value) => instances['schedule'] = value;

  List<String> get goals => List<String>.from(data['goals']);

  List<String> get epics => List<String>.from(data['epics']);

  List<String> get subtasks => List<String>.from(data['subtasks']);

  List<String> get assignees => List<String>.from(data['assignees']);

  List<String> get comments => List<String>.from(data['comments']);

  List<String> get issues => List<String>.from(data['issues']);

  List<String> get documents => List<String>.from(data['documents']);

  double get priority => data['priority'];
  set priority(double value) => data['priority'] = value;

  String get state => data['state'];
  set state(String value) => data['state'] = value;

  List<String> get categoryTags => List<String>.from(data['categoryTags']);

  Context get context => instances['context'];
  set context(Context value) => instances['context'] = value;

  @override
  Map<String, dynamic> toJSON() {
    data.forEach((String k, dynamic v) {
      if (v is SuperObject) {
        data[k] = v.toJSON();
      }
      if (k == 'schedule' || k == 'context') {
        data[k] = instances[k].toJSON();
      }
    });
    return data;
  }
}

class Event extends LSObject {
  Event(Map<String, dynamic> data) : super(data) {
    instances['schedule'] = Schedule(data['schedule']);
    instances['anchors'] = data['anchors'].map((v) => Anchor(v)).toList();
  }

  String get name => data['name'];
  set name(String value) => data['name'] = value;

  String get notes => data['notes'];
  set notes(String value) => data['notes'] = value;

  Schedule get schedule => instances['schedule'];
  set schedule(Schedule value) => instances['schedule'] = value;

  List<String> get tasks => List<String>.from(data['tasks']);

  List<Anchor> get anchors => List<Anchor>.from(instances['anchors']);

  @override
  Map<String, dynamic> toJSON() {
    data.forEach((String k, dynamic v) {
      if (v is SuperObject) {
        data[k] = v.toJSON();
      }
      if (k == 'schedule') {
        data[k] = instances[k].toJSON();
      }
      if (k == 'anchors') {
        data[k] = instances[k].map((v) => v.toJSON()).toList();
      }
    });
    return data;
  }
}

class Document extends LSObject {
  Document(Map<String, dynamic> data) : super(data) {
    instances['created'] = Schedule(data['created']);
    instances['lastUpdated'] = Schedule(data['lastUpdated']);
  }

  String get name => data['name'];
  set name(String value) => data['name'] = value;

  String get description => data['description'];
  set description(String value) => data['description'] = value;

  Schedule get created => instances['created'];
  set created(Schedule value) => instances['created'] = value;

  Schedule get lastUpdated => instances['lastUpdated'];
  set lastUpdated(Schedule value) => instances['lastUpdated'] = value;

  String get lastModifier => data['lastModifier'];
  set lastModifier(String value) => data['lastModifier'];

  List<String> get sharedWith => List<String>.from(data['sharedWith']);

  String get source => data['source'];
  set source(String value) => data['source'] = value;

  @override
  Map<String, dynamic> toJSON() {
    data.forEach((String k, dynamic v) {
      if (v is SuperObject) {
        data[k] = v.toJSON();
      }
      if (k == 'created' || k == 'lastUpdated') {
        data[k] = instances[k].toJSON();
      }
    });
    return data;
  }
}

class Prototype extends LSObject {
  Prototype(Map<String, dynamic> data) : super(data);

  String get name => data['name'];
  set name(String value) => data['name'] = value;

  String get description => data['description'];
  set description(String value) => data['description'] = value;

  String get archetype => data['archetype'];
  set archetype(String value) => data['archetype'] = value;

  String get deployment => data['deployment'];
  set deployment(String value) => data['deployment'] = value;

  List<String> get hooks => List<String>.from(data['hooks']);

  String get source => data['source'];
  set source(String value) => data['source'];

  void execute() {}
}

class Issue extends LSObject {
  Issue(Map<String, dynamic> data) : super(data);
}

class Message extends LSObject {
  Message(Map<String, dynamic> data) : super(data);
}

abstract class HyperObject implements ControllableObject {
  Map<String, dynamic> data;
  final Map<String, dynamic> instances = {};
  HyperObject(this.data);

  String get id => data['objectId'];
  String get type => data['type'];

  Map<String, dynamic> toJSON() {
    data.forEach((String k, dynamic v) {
      if (v is SuperObject) {
        data[k] = v.toJSON();
      }
    });
    return data;
  }
}

class StackObject extends HyperObject {
  StackObject(Map<String, dynamic> data) : super(data);

  List<String> get goals => data['goals'];
  Map<String, dynamic> get context => Map<String, dynamic>.from(data['context']);
  List<String> get projects => List<String>.from(data['projects']);
  List<String> get workspaces => List<String>.from(data['workspaces']);
  List<String> get messages => List<String>.from(data['messages']);
  List<String> get prototypes => List<String>.from(data['prototypes']);
  List<String> get tickets => List<String>.from(data['tickets']);
  List<String> get bin => List<String>.from(data['bin']);
  Map<String, dynamic> get automkit => Map<String, dynamic>.from(data['automkit']);
}

class WorkbenchObject extends HyperObject {
  WorkbenchObject(Map<String, dynamic> data) : super(data);

  Map<String, dynamic> get xauth => Map<String, dynamic>.from(data['xauth']);
  Map<String, dynamic> get perfOps => Map<String, dynamic>.from(data['performanceOptimisation']);
  String get stack => data['stack'];
  set stack(String value) => data['stack'] = value;
  Map<String, dynamic> get permissions => Map<String, dynamic>.from(data['permissions']);
  Map<String, dynamic> get configs => Map<String, dynamic>.from(data['configs']);
  Map<String, dynamic> get missionControl => Map<String, dynamic>.from(data['missionControl']);
  List<String> get stickies => List<String>.from(data['stickies']);
}

class LicenseObject extends HyperObject {
  LicenseObject(Map<String, dynamic> data) : super(data);

  String get licenseId => data['licenseId'];
  set licenseId(String value) => data['licenseId'] = value;

  String get dateCreated => data['dateCreated'];
  set dateCreated(String value) => data['dateCreated'] = value;

  bool get isLicenseValid => data['isLicenseValid'];
  set isLicenseValid(bool value) => data['isLicenseValid'] = value;

  String get licenseInvalidityReason => data['licenseInvalidityReason'];
  set licenseInvalidityReason(String value) => data['licenseInvalidityReason'] = value;

  String get licenseType => data['licenseType'];
  set licenseType(String value) => data['licenseType'] = value;

  int get contributionScore => data['contributionScore'];
  set contributionScore(int value) => data['contributionScore'] = value;

  List get products => data['products'];

  String get displayName => data['displayName'];
  set displayName(String value) => data['displayName'] = value;

  String get password => data['password'];
  set password(String value) => data['password'] = value;

  String get email => data['email'];
  set email(String value) => data['email'] = value;

  String get profileIcon => data['profileIcon'];
  set profileIcon(String value) => data['profileIcon'] = value;

  List<String> get permissions => List<String>.from(data['permissions']);

  List<String> get remarks => List<String>.from(data['remarks']);
}
 */