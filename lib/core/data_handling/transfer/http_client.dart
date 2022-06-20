part of core.data_handling;

class HttpClient {
  static const String baseUrl =
      "https://infinitumlabsinc.editorx.io/lighthousecloud/_functions/";

  static Future<ResponseObject> get(RequestObject requestObject) async {
    return http.get(
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
