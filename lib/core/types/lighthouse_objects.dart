part of core.types;

////////////////////
// LighthouseObjects
////////////////////

abstract class LighthouseObject {
  final Map<String, dynamic> json;

  const LighthouseObject(this.json);

  String get revisionId => json['revId'];
  set revisionId(String revId) => json['revId'] = revId;

  String get objectId => json['id'];
  set objectId(String id) => json['id'] = id;
}

abstract class CoreObject extends LighthouseObject {
  const CoreObject(Map<String, dynamic> json) : super(json);
}

abstract class SubObject extends LighthouseObject {
  const SubObject(Map<String, dynamic> json) : super(json);
}

////////////////////
// CoreObjects
////////////////////

class Workbench extends CoreObject {
  const Workbench(Map<String, dynamic> json) : super(json);

  List<String> get projects => json['projects'];
}

////////////////////
// SubObjects
////////////////////

class Context extends SubObject {
  const Context(Map<String, dynamic> json) : super(json);
}
