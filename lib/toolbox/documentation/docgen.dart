/// Generates documentation from Dart source code.
/// L2
/// L3
/// L4
/// End
part of toolbox.documentation;

class DocGen {
  static const String emDash = '—';
  static const String thickDash = '___thickSep';

  static String stringFromDocComments(List<String> srcLines) {
    return srcLines
        .map((String line) => line.replaceAll('///', '').replaceAll('\n', ' '))
        .toList()
        .join()
        .trimLeft();
  }

  static String generateLibraryDocs(String src) {
    final List<String> output = [];
    final List<String> lines = src.split('\n');
    final int length = lines.length;

    String currentLib = 'library_unknown';
    String currentLine = '';
    bool parsingExposedClasses = false;
    for (int i = 0; i < length; i++) {
      currentLine = lines[i].trim();
      if (currentLine == '') continue;
      if (currentLine.startsWith('library')) {
        currentLib = currentLine.replaceAll('library ', '').replaceAll(';', '');
        output
          ..add(currentLib)
          ..add(thickDash)
          ..add(stringFromDocComments(lines.getRange(0, i).toList()).trim());
      }

      if (currentLine.startsWith('export')) {
        if (!parsingExposedClasses) {
          parsingExposedClasses = true;
          output.add("APIs_h2");
        }
        final String shownLibrary = currentLib +
            '.' +
            currentLine.split('show')[0].split('/').last.split('.').first;
        final List<String> shownClasses = currentLine
            .split('show')[1]
            .replaceAll(';', '')
            .trim()
            .split(',')
            .map((String _class) => _class.trim())
            .toList();
        output
          ..add(shownLibrary)
          ..add(shownClasses.join('\n'));
      }
    }
    return output.join('\n');
  }

  static String generateAPIDocs(String src) {
    return "";
  }
}
