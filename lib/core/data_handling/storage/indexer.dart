part of core.data_handling.storage;

/// The [Indexer] performs administrative tasks for the [Vault]. Its job is to keep
/// track of which [LighthouseObject]s are being stored in the [Vault], and which
/// of them are [dirty](https://github.com). During each [sync](https://github.com),
/// it only sends dirty objects to the DB, and if there are new objects in the DB's
/// response, it updates the [Vault] accordingly. Basically does attendance-taking
/// for objects in the Vault.
class Indexer {
  static final Map<String, String> index = {};
  static final List<String> dirtyObjects = [];
  static final List<String> deletions = [];

  static void init() {}

  /// Start tracking a new [LighthouseObject] in its [index].
  /// This is usually called by [Vault.create] when objects are created on the client side,
  /// because any objects created on the DB side would already have been inserted
  /// automatically during [loadSnapshot].
  static Future<void> insert(LighthouseObject object) async {
    index.addEntries([MapEntry(object.objectId, object.revisions.last)]);
    markObjectAsDirty(object.objectId);
  }

  /// During each [sync](https://github.com), the DB sends a [snapshot](https://github.com)
  /// in the payload of its response. This method processes that snapshot, loads new objects
  /// into the [Vault], updates existing ones, and updates the [index] as well.
  static Future<void> loadSnapshot(Map<String, dynamic> payload) async {
    // String objectId: JSON {}
    Utils.iterateOver<MapEntry<String, dynamic>>(payload.entries, (obj) {
      index.putIfAbsent(obj.key, () => obj.value['revs'].last);
      Vault.update(obj.key, obj.value);
    });
  }

  static Future<List<LighthouseObject>> fetchDirtyObjects() async {
    final List<LighthouseObject> dirtyObjs = [];
    Utils.iterateOver<String>(
      dirtyObjects,
      (String objId) async => dirtyObjs.add(await Vault.get(objId)),
    );
    return dirtyObjs;
  }

  static Future<void> markObjectAsDirty(String objectId) async {
    if (!dirtyObjects.contains(objectId)) dirtyObjects.add(objectId);
  }
}
