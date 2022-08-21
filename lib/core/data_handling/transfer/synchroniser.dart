part of core.data_handling.transfer;

/// The [Synchroniser] ensures that the [Vault] and DB synchronise their data
/// regularly. It also takes care of situations where the user is offline.
class Synchroniser {
  /// The rate, in seconds, at which polling is done.
  static int pollRate = 30;
  static final Timer _timer = Timer.periodic(
    Duration(seconds: pollRate), (Timer t) => null, //performSync(),
  );

  static void init() {}

  /// Cancels the [Timer]
  static void deinit() {
    _timer.cancel();
  }

  static Future<void> performSync() async {
    if (!(await HttpClient.testConnection())) {}
    Indexer.fetchDirtyObjects().then((List<LighthouseObject> objects) {
      if (objects.isEmpty) return;
      HttpClient.batchUpdate(
        RequestObject(emptyRequestMap)
          ..setSlug(Slug.put)
          ..setJwtString('jwtString')
          ..setPayload(
            {}..addEntries(
                List<MapEntry<String, dynamic>>.generate(
                  objects.length,
                  (i) => MapEntry(objects[i].objectId, objects[i].json),
                ),
              ),
          ),
      ).then((ResponseObject responseObject) {
        Indexer.loadSnapshot(responseObject.payload);
      });
    });
  }
}
