import 'dart:math';
import 'dart:convert';
import '../types/types.dart';

final void Function() emptyCallback = () {};

class ObjectId {
  static final String _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  static final Random _rnd = Random();
  static String generateAlphaNumString() =>
      String.fromCharCodes(Iterable.generate(
          8, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  /// Generates an ICS-RIDv4 [String].
  /// IIS: Infinitum Code Standards
  /// RID: Resource Identifier
  /// v4: v4 of the format, an example looks like: wb-nr8ybar4-voefiyg7
  static String generateId(String objectPrefix, String userKey) =>
      '$objectPrefix-' + ObjectId.generateAlphaNumString() + '-$userKey';
}

class Base64Url {
  static String encode(dynamic obj) =>
      base64Url.encode(utf8.encode(jsonEncode(obj)));
  static dynamic decode(String encodedString) =>
      utf8.decode(base64Url.decode(encodedString));
}

/// A utility class that contains all scripts, no matter how different, that
/// generate Dart code.
class CodegenScripts {
  static String lhObjClassFromJson(JSON json) {
    return '';
  }
}
