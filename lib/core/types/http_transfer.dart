part of core.types;

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

  String get jwtString => jsonData['headers']['auth']['jwt'];
  Slug get slug => jsonData['headers']['slug'];

  setSlug(Slug slug) => jsonData['headers']['slug'] = slug.string;

  setJwtString(String jwtString) =>
      jsonData['headers']['auth']['jwt'] = jwtString;

  setPayload(JSON payload) => jsonData['body']['payload'] = payload;
}

class ResponseObject {
  final JSON jsonData;

  const ResponseObject(this.jsonData);

  int get statusCode => jsonData['body']['status']['code'];
  String get statusMsg => jsonData['body']['status']['msg'];
  String get jwtString => jsonData['headers']['auth']['jwt'];
  JSON get payload => jsonData['body']['payload'];
}
