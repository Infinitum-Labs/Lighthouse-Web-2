part of core.data_handling.storage;

/// [Vault] is the client-side storage manager for Lighthouse. It also contains a cache
/// of [LighthouseObject]s to reduce network usage. However, this means that a whole
/// system has to be put in place to ensure objects synchronise properly with the DB
/// and that changes are made as the user would expect them to. Do note that the Vault
/// is different from the cache. A `delete` operation performed on the Vault is reflected
/// in the DB in the next sync.
/// [Learn more](https://coda.io/@lighthouse/lighthouse-developer-guidebook/vault-5)
class Vault {
  static final Map<String, LighthouseObject> _cache = {};
  static final Map<String, LighthouseObject> _deletedObjectsCache = {};

  /// Initialises the cache, [HttpClient], [Indexer], [Synchroniser] and checks
  /// whether [IdbFactory] is supported by the device.
  ///
  /// Defaults to using [Map] as a cache. Since Dart's [Map] implementation uses
  /// a HashTable, it is O(1) time complexity, making it suitable for lookups on
  /// moderate- to large-sized structures. [List], on the other hand, is O(n) time
  /// complexity and hence more suitable for smaller data structures.
  static bool init() {
    /* if (!IdbFactory.supported) return false;
    IdbFactory idbFactory = getIdbFactory()!;
    idbFactory.open(
      'dbName',
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent e) {},
    );
    return true; */
    HttpClient.init();
    Indexer.init();
    Synchroniser.init();
    return true;
  }

  /// Calls [Synchroniser.deinit] and [HttpClient.deinit].
  static void deinit() {
    Synchroniser.deinit();
    HttpClient.deinit();
  }

  /// Returns a reference to an object in cache.
  static Future<LighthouseObject> get(String objectId) async {
    if (_cache.containsKey(objectId)) return _cache[objectId]!;
    return HttpClient.get(
      RequestObject({}),
    ).then((ResponseObject responseObject) {
      return create(Workbench.fromJSON(responseObject.payload));
    });
  }

  /// Adds the [LighthouseObject] to the Vault and returns it.
  ///
  /// Automatically updates the [Indexer] as well.
  static T create<T extends LighthouseObject>(T obj) {
    _cache[obj.objectId] = obj;
    Indexer.insert(obj);
    return obj;
  }

  /// Updates the existing [LighthouseObject] instance by overriding its
  /// `json` property with the new [JSON] data. Returns the updated
  /// [LighthouseObject].
  ///
  /// If only certain properties need to be changed, consider
  /// doing the following:
  /// ```dart
  /// LighthouseObject workbench = Workbench.fromJSON({});
  /// workbench.push(workbench.projects, "project #1");
  /// Vault.update(workbench.objectId, workbench.json);
  /// ```
  static Future<LighthouseObject> update(String objectId, JSON json) async {
    return Vault.get(objectId).then((LighthouseObject obj) {
      obj.json
        ..clear()
        ..addAll(json);
      Indexer.markObjectAsDirty(obj.objectId);
      return obj;
    });
  }

  /// Moves the specified [LighthouseObject] from the [_cache] to the
  /// [_deletedObjectsCache], updating the [Indexer]. This ensures that cache lookup
  /// is not delayed by iterating over useless objects, while also preserving the
  /// objects in case of reversion. [Learn more](https://github.com)
  static Future<void> delete(String objectId) async {
    _deletedObjectsCache[objectId] = _cache.remove(objectId)!;
    Indexer.deletions.add(objectId);
  }

  static Future<List<LighthouseObject>> getAll() async {
    return <LighthouseObject>[];
  }
}
