part of core.data_handling.transfer;

enum Slug {
  auth,
  get,
  put,
  delete,
}

class RequestObject {
  final JSON jsonData;

  /// Either pass a complete [Map], or use an [emptyRequestMap] from `utils.dart`.
  /// It conains the default keys such as 'headers', 'auth', 'jwt' set to empty values.
  RequestObject(this.jsonData);

  String get jwtString => jsonData['headers']['Authentication'];
  Slug get slug => jsonData['headers']['slug'];
  String get origin => jsonData['headers']['origin'];

  setSlug(Slug slug) => jsonData['headers']['slug'] = slug.string;
  setOrigin(String origin) => jsonData['headers']['origin'] = origin;
  setJwtString(String jwtString) =>
      jsonData['headers']['Authentication'] = jwtString;
  setPayload(JSON payload) => jsonData['body']['payload'] = payload;
}

class ResponseObject {
  final JSON jsonData;
  late DBError? error;

  ResponseObject(this.jsonData) {
    /* if (jsonData['body']['status']['code'] > 200) {
      error = DBError.fromJSON(jsonData['body']['status']);
    } */
  }

  int get statusCode => jsonData['body']['status']['code'];
  String get statusMsg => jsonData['body']['status']['msg'];
  String get jwtString => jsonData['headers']['Authentication'];
  JSON get payload => jsonData['body']['payload'];
}

class HttpClient {
  static late SatelliteStation _satelliteStation;
  static const bool _debugMode = false;
  static const String baseUrl =
      "https://infinitumlabsinc.editorx.io/lighthousecloud/_functions";

  static void init(SatelliteStation satStation) {
    _satelliteStation = satStation;
  }

  /// This test checks whether a connection can be established with the DB.
  ///
  /// It ensures not only that a WiFi network is available, but also that the
  /// connection actually works. It is used to decide whether to activate offline
  /// mode or not.
  static Future<bool> testConnection() async =>
      InternetConnectionChecker().hasConnection;

  /// Checks whether the user is connected to mobile data or WiFi.
  ///
  /// This affects the polling rate of the [Synchroniser._timer], throttled by `performSync`
  static Future<void> testConnectionType() async => InternetConnectionChecker();

  static void deinit() {}

  static Future<ResponseObject> get(RequestObject requestObject) async {
    return handleResponse(
      jsonDecode(
        await HttpRequest.requestCrossOrigin('$baseUrl/test', method: 'GET'),
      ),
    );
  }

  static Future<ResponseObject> get_test(RequestObject requestObject) async {
    return handleResponse(
      jsonDecode(
        (await HttpRequest.request(
                '$baseUrl/test?payload=${Uri.encodeComponent(jsonEncode(requestObject.jsonData))}',
                method: 'GET'))
            .response,
      ),
    );
  }

  static Future<ResponseObject> get_session(RequestObject requestObject) async {
    return handleResponse(
      jsonDecode(
        await HttpRequest.requestCrossOrigin(
          ("$baseUrl/session?creds=true"),
          method: 'GET',
          sendData: jsonEncode({
            "headers": {"Authorization": "", "slug": ""},
            "body": {
              "payload": {"username": 1, "password": 2}
            }
          }),
        ),
      ),
    );
  }

  /// Handles the raw response received, processing the error if there is one.
  ///
  /// The error is included when creating the [ResponseObject], and is then accessed
  /// by the method that called the [get] request in the first place, through
  /// [ResponseObject.error]
  static ResponseObject handleResponse(JSON rawResponse) {
    return ResponseObject(rawResponse);
  }

  static Future<ResponseObject> batchUpdate(RequestObject requestObject) async {
    /* if (_debugMode) return const ResponseObject({});
    return _httpClient.get(
      Uri.parse(baseUrl + 'auth'), // requestObject.slug.string
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${requestObject.jwtString}',
      },
    ).then((http.Response response) {
      return ResponseObject(
        jsonDecode(response.body),
      );
    }); */
    return ResponseObject({});
  }
}

extension HttpUtils on String {
  String addQueryParams(JSON payload) =>
      "?payload=${Uri.encodeComponent(jsonEncode(payload))}";
}
