part of core.utils;

class Logger {
  static late File _logFile;
  static void init() {
    _logFile = File('./LOGS.txt');
    _logFile.writeAsString('INITIALISED');
  }

  static void log(dynamic msg, [dynamic src = "<anon>"]) =>
      _logFile.writeAsStringSync(
        "${DateTime.now().toString()} | ${src.toString()} >> ${msg.toString()}",
        mode: FileMode.append,
      );

  static void deinit() {}
}
