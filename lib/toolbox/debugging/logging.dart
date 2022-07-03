part of toolbox.debugging;


abstract class Logger {
  void log(dynamic msg, [dynamic src = "<anon>"]);
}
/* class LogDaemonClient {
  final String serverAddr;
  LogDaemonClient(this.serverAddr);

  void log(String msg, [LogType logType = LogType.log]) {
    http.get(
      Uri.parse(
          "$serverAddr?action=log&logType=${logType.string}&payload=${base64.encode(utf8.encode(msg))}"),
    );
  }
}



class DevLogger extends Logger {
  final VoidCallback _dumpAppCallback;
  final VoidCallback _dumpRenderTreeCallback;
  DevLogger(
    this._dumpAppCallback,
    this._dumpRenderTreeCallback,
  );

  void dumpApp() => _dumpAppCallback;
  void dumpRenderTree() => _dumpRenderTreeCallback();

  @override
  void log(dynamic msg, [dynamic src = "<anon>"]) => dev.log(
      "${DateTime.now().toString()} >> ${msg.toString()} [${src.toString()}]");
}

class HttpLogger extends Logger {
  final String _loggingEndpontUrl =
      "bbd77307-b57e-49af-8c9b-f2128d646f96.mock.pstmn.io";

  @override
  void log(dynamic msg, [dynamic src = "<anon>"]) => http.get(
        Uri.https(
          _loggingEndpontUrl,
          '/log',
          {
            'msg': "${DateTime.now().toString()} >> ${msg.toString()}",
            'src': src.toString(),
          },
        ),
      );
}

class FileLogger extends Logger {
  late io.File _logFile;
  FileLogger() {
    _logFile = io.File('./logs.txt');
    _logFile.writeAsStringSync('');
  }

  @override
  void log(dynamic msg, [dynamic src = "<anon>"]) {
    _logFile.writeAsStringSync(
      "${DateTime.now().toString()} >> ${msg.toString()} [${src.toString()}]",
      mode: io.FileMode.append,
    );
  }
}
 */