part of core.data_handling.storage;

/// [Vault] is the client-side storage manager for Lighthouse. It also contains a cache
/// of [LighthouseObject]s to reduce network usage. However, this means that a whole
/// system has to be put in place to ensure objects synchronise properly with the DB
/// and that changes are made as the user would expect them to. Do note that the Vault
/// is different from the cache. A `delete` operation performed on the Vault is reflected
/// in the DB in the next sync.
/// [Learn more](https://coda.io/@lighthouse/lighthouse-developer-guidebook/vault-5)
class Vault {
  static late SatelliteStation _satelliteStation;
  static final Map<String, LighthouseObject> _cache = {};
  static final Map<String, LighthouseObject> _deletedObjectsCache = {};

  /// Initialises the cache, [HttpClient], [Indexer], [Synchroniser] and checks
  /// whether [IdbFactory] is supported by the device.
  ///
  /// Defaults to using [Map] as a cache. Since Dart's [Map] implementation uses
  /// a HashTable, it is O(1) time complexity, making it suitable for lookups on
  /// moderate- to large-sized structures. [List], on the other hand, is O(n) time
  /// complexity and hence more suitable for smaller data structures.
  static bool init(SatelliteStation satStation) {
    /* if (!IdbFactory.supported) return false;
    IdbFactory idbFactory = getIdbFactory()!;
    idbFactory.open(
      'dbName',
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent e) {},
    );
    return true; */
    HttpClient.init(satStation);
    Indexer.init();
    Synchroniser.init();
    return true;
  }

  /// Calls [Synchroniser.deinit] and [HttpClient.deinit].
  static void deinit() {
    Synchroniser.deinit();
    HttpClient.deinit();
  }

  static bool contains(String objectId) =>
      _cache.containsKey(objectId) ? true : false;

  /// Returns a reference to an object in cache.
  static Future<LighthouseObject> get(String objectId) async {
    if (contains(objectId)) return _cache[objectId]!;
    // todo: check DB for object, throw if still not found
    throw ObjectNotFound(objectId);
    /* return HttpClient.get(
      RequestObject(emptyRequestMap),
    ).then((ResponseObject responseObject) {
      return create(Workbench.fromJSON(responseObject.payload));
    }); */
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
  /// Vault.update(workbench.objectId, workbench);
  /// ```
  /// If properties need to be overwritten, the JSON values can be overwritten:
  /// ```dart
  /// LighthouseObject workbench = Workbench.fromJSON({});
  /// workbench.json['property'] = 'value';
  /// Vault.update(workbench.objectId, workbench);
  /// ```
  static Future update(String objectId, LighthouseObject newObj) async {
    return Vault.get(objectId).then((LighthouseObject obj) {
      if (newObj.runtimeType == obj.runtimeType) {
        final List<String> revs = obj.revisions;
        final String id = obj.objectId;
        obj.json
          ..clear()
          ..addAll(
            newObj.json
              ..update('id', (_) => id)
              ..update('revs', (_) => revs),
          );
        Indexer.markObjectAsDirty(obj.objectId);
        return obj;
      } else {
        throw OverwrittenObjectTypeMismatch(
            objectId, obj.runtimeType, newObj.runtimeType);
      }
    });
  }

  /// Moves the specified [LighthouseObject] from the [_cache] to the
  /// [_deletedObjectsCache], updating the [Indexer] and returning the deleted object.
  ///
  /// This ensures that cache lookup is not delayed by iterating over useless objects,
  /// while also preserving the objects in case of reversion. [Learn more](https://github.com)
  static Future<LighthouseObject> delete(String objectId) async {
    if (!contains(objectId)) throw ObjectNotFound(objectId);
    _deletedObjectsCache[objectId] = _cache.remove(objectId)!;
    Indexer.deletions.add(objectId);
    return _deletedObjectsCache[objectId]!;
  }

  /// Returns all the [LighthouseObject]s in the [_cache].
  ///
  /// Usually used by the [engines](github.com) to sort and organise the objects
  /// for their respective purposes.
  static Future<List<LighthouseObject>> getAll() async {
    return _cache.values.toList();
  }
}
