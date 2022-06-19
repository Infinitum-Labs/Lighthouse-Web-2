part of core.data_handling;

class Store {
  static bool init() {
    if (!IdbFactory.supported) return false;
    IdbFactory idbFactory = getIdbFactory()!;
    idbFactory.open(
      'dbName',
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent e) {},
    );
    return true;
  }

  static LighthouseObject get(String objectId) {
    /// if in cache
    ///   return from cache
    /// else
    ///   add to HTTP request queue, register callback
    ///   callback puts new data into store, returns `Storage.get`
    return const Workbench({});
  }

  static void put(LighthouseObject lhObj) {
    //
  }

  static LighthouseObject modify(String objectId, LighthouseObject lhObj) {
    return const Workbench({});
  }

  static void delete(String objectId) {
    //
  }
}
