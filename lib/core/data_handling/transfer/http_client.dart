part of core.data_handling.transfer;

class HttpClient {
  static const bool _debugMode = false;
  static late http.Client _httpClient;
  static const String baseUrl =
      "https://infinitumlabsinc.editorx.io/lighthousecloud/_functions/";

  static void init() {
    _httpClient = http.Client();
  }

  /// Closes [http.Client] connection, like a polite user of the HTTP protocol should.
  static void deinit() {
    _httpClient.close();
  }

  static Future<ResponseObject> get(RequestObject requestObject) async {
    if (_debugMode) return const ResponseObject({});
    return _httpClient.get(
      Uri.parse(baseUrl + 'auth'), // requestObject.slug.string
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${requestObject.jwtString}',
      },
    ).then((http.Response response) {
      return ResponseObject(
        jsonDecode(response.body),
      );
    });
  }

  static Future<ResponseObject> batchUpdate(RequestObject requestObject) async {
    if (_debugMode) return const ResponseObject({});
    return _httpClient.get(
      Uri.parse(baseUrl + 'auth'), // requestObject.slug.string
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${requestObject.jwtString}',
      },
    ).then((http.Response response) {
      return ResponseObject(
        jsonDecode(response.body),
      );
    });
  }
}
