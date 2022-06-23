library toolbox.debugging.log_daemon;

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum LogType {
  info,
  log,
  warn,
  err,
}

class LogDaemon {
  void handle(Map<String, String> queryParams) {
    if (queryParams['action'] == 'log') {
      print(
        createLog(
          (queryParams['logType'] as String).asLogType,
          (utf8.decode(
            base64.decode(queryParams['payload']!),
          )),
        ),
      );
    }
  }

  String createLog(LogType logType, String msg) {
    String timestamp = DateTime.now().asTimestamp;
    String logTypeString = logType.string;
    return logTypeString.ansiColorCode +
        "[$timestamp] $msg".padRight(stdout.terminalColumns - 4) +
        logTypeString.toUpperCase().padLeft(4) +
        "\x1B[0m";
  }

  Future pingSelf(String serverAdddr) {
    return Future.delayed(const Duration(seconds: 1), () {
      String payload = base64.encode(utf8.encode("Ping self success"));
      http
          .get(
              Uri.parse("$serverAdddr?action=log&logType=log&payload=$payload"))
          .then(
        (http.Response response) {
          if (response.statusCode == 200) {
            print(response.body);
          } else {
            print(createLog(LogType.warn, "Ping self failed"));
          }
        },
      );
    });
  }
}

main() async {
  LogDaemon logDaemon = LogDaemon();
  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8000);
  final String serverAddr = "http://${server.address.address}:${server.port}";
  print("LogDaemon activated on $serverAddr");
  print("================================================");
  logDaemon.pingSelf(serverAddr);

  await for (var request in server) {
    logDaemon.handle(request.uri.queryParameters);
    request.response.close();
  }
}

extension StringUtils on String {
  LogType get asLogType {
    switch (this) {
      case 'log':
        return LogType.log;
      case 'warn':
        return LogType.warn;
      case 'err':
        return LogType.err;
      case 'info':
        return LogType.info;
      default:
        return LogType.log;
    }
  }

  String get ansiColorCode {
    switch (this) {
      case 'log':
        return "\x1B[32m";
      case 'warn':
        return "\x1B[33m";
      case 'err':
        return "\x1B[31m";
      case 'info':
        return "\x1B[36m";
      default:
        return "\x1B[32m";
    }
  }
}

extension EnumUtils on Enum {
  String get string =>
      toString().replaceAll("${toString().split('.')[0]}.", '');
}

extension DateTimeUtils on DateTime {
  String get asTimestamp {
    return "$hour:$minute:$second:$millisecond";
  }
}

class KeystrokeListener {
  /* Future main() async {
  stdin
    ..lineMode = false
    ..echoMode = false;
  StreamSubscription subscription;
  subscription = io.stdin.listen((List<int> codes) {
    var first = codes.first;
    var len = codes.length;
    var key;
    if (len == 1 && ((first > 0x01 && first < 0x20) || first == 0x7f)) {
      // Control code. For example:
      // 0x09 - Tab
      // 0x10 - Enter
      // 0x1b - ESC
      if (first == 0x09) {
        subscription.cancel();
      }
      key = codes.toString();
    } else if (len > 1 && first == 0x1b) {
      // ESC sequence.  For example:
      // [ 0x1b, 0x5b, 0x41 ] - Up Arrow
      // [ 0x1b, 0x5b, 0x42 ] - Down Arrow
      // [ 0x1b, 0x5b, 0x43 ] - Right Arrow
      // [ 0x1b, 0x5b, 0x44 ] - Left Arrow
      key = '${codes.toString()} ESC ${String.fromCharCodes(codes.skip(1))}';
    } else {
      key = utf8.decode(codes);
    }
    print(key);
  }); */
}
