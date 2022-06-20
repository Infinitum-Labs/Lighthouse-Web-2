part of core.types;

////////////////////
// LighthouseObjects
////////////////////

abstract class LighthouseObject {
  final JSON json;

  const LighthouseObject(this.json);

  String get revisionId => json['revId'];
  set revisionId(String revId) => json['revId'] = revId;

  String get objectId => json['id'];
  set objectId(String id) => json['id'] = id;
}

abstract class CoreObject extends LighthouseObject {
  const CoreObject(JSON json) : super(json);
}

abstract class SubObject extends LighthouseObject {
  const SubObject(JSON json) : super(json);
}

////////////////////
// CoreObjects
////////////////////

class Workbench extends CoreObject {
  const Workbench(JSON json) : super(json);

  List<String> get projects => json['projects'];
}

////////////////////
// SubObjects
////////////////////

class Context extends SubObject {
  const Context(JSON json) : super(json);
}
