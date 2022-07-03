part of core.data_handling.transfer;

class HttpClient {
  static const bool _debugMode = false;
  static const String baseUrl =
      "https://infinitumlabsinc.editorx.io/lighthousecloud/_functions";

  static void init() {}

  /// This test merely checks whether a connection can be established with the DB.
  ///
  /// When checking whether the user is offline, this method is called after
  static Future<bool> testConnection() async {
    String result =
        await HttpRequest.requestCrossOrigin(baseUrl + '/test', method: 'GET');
    if (ResponseObject(jsonDecode(result)).statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static void deinit() {}
//https://stackoverflow.com/questions/49648022/check-whether-there-is-an-internet-connection-available-on-flutter-app
  static Future<ResponseObject> getD(RequestObject requestObject,
      [Function(ResponseObject)? cb]) async {
    if (_debugMode) return cb!(const ResponseObject({}));
    //String str = await HttpRequest.requestCrossOrigin('$baseUrl/test');
    HttpRequest.request(
      '$baseUrl/test',
      method: 'GET',
      requestHeaders: {
        'Authorization': requestObject.jwtString,
        'Access-Control-Allow-Origin':
            'https://obsidian418-infinitum-labs-lighthouse-web-5gp5rgqwq299q-8084.githubpreview.dev',
        'Access-Control-Allow-Credentials': 'true',
      },
    );

    return ResponseObject(jsonDecode('{"a":1}'));
    /* HttpRequest req = HttpRequest()
      ..open(
          'GET',
          baseUrl +
              '/test') // ..open('GET', baseUrl + requestObject.slug.string)
      ..setRequestHeader('Authorization', requestObject.jwtString)
      ..setRequestHeader('accept', '*')
      ..onError.listen((_) {});
    req.onLoadEnd.listen((ProgressEvent e) => handleResponse(e, req, cb!));
    req.send(); */
  }

  static Future<ResponseObject> getX(RequestObject requestObject) async {
    return HttpRequest.request(
      '$baseUrl/test',
      method: 'GET',
      requestHeaders: {
        'Authorization': requestObject.jwtString,
        'Access-Control-Allow-Origin':
            'https://obsidian418-infinitum-labs-lighthouse-web-5gp5rgqwq299q-8084.githubpreview.dev',
        'Access-Control-Allow-Credentials': 'true',
      },
    ).then((HttpRequest req) {
      return ResponseObject(jsonDecode(req.response));
    });
  }

  static Future<ResponseObject> get(RequestObject requestObject) async {
    return ResponseObject(
      jsonDecode(
        await HttpRequest.requestCrossOrigin('$baseUrl/test', method: 'GET'),
      ),
    );
  }

  static void handleResponse(
    ProgressEvent event,
    HttpRequest request,
    Function(ResponseObject) callback,
  ) {
    /* if (request.readyState == 4 && request.status == 200) {
     
    } */
    callback(ResponseObject(jsonDecode(request.responseText ?? '{}')));
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
