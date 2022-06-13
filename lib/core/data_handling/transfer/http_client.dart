class RequestObject {
  final Map<String, dynamic> jsonData;

  RequestObject([this.jsonData = const {}]);
}

class ResponseObject {
  final Map<String, dynamic> jsonData;

  ResponseObject(this.jsonData);

  int get statusCode => jsonData['body']['status']['code'];
  String get statusMsg => jsonData['body']['status']['msg'];
  String get jwtString => jsonData['headers']['auth']['jwt'];
  Map<String, dynamic> get payload => jsonData['body']['payload'];
}
