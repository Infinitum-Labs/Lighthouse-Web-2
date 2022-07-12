part of core.utils.general;

final void Function() emptyCallback = () {};
const JSON emptyRequestMap = {
  'headers': {
    'auth': {'jwt': ''},
    'slug': ''
  },
  'body': {'payload': {}}
};
const JSON emptyLighthouseObjectMap = {
  'revs': [],
  'id': '',
};

class Utils {
  static void iterateOver<T>(Iterable<T> iterable, Function(T obj) callback) {
    final int length = iterable.length;
    for (int i = 0; i < length; i++) {
      callback(iterable.elementAt(i));
    }
  }
}

class ObjectId {
  static const String _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
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

extension EnumUtils on Enum {
  String get string =>
      toString().replaceAll("${toString().split('.')[0]}.", '');
}

// Add flutter to path permanently
// echo 'export PATH="$PATH:/workspaces/Lighthouse-Web/flutter/bin"' >> $HOME/.bashrc