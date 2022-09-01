part of core.engines.wiz;

class Command {
  final Token root;
  final List<Token> subcommands;
  final Args args;
  final Flags flags;

  const Command(this.root, this.subcommands, this.args, this.flags);
}

class Args {
  final List<Token> positionalArgs;
  final Map<String, List<Token>> namedArgs;

  const Args({this.positionalArgs = const [], this.namedArgs = const {}});
}

class Flags {
  final List<Token> globalFlags;
  final List<Token> localFlags;

  const Flags({this.globalFlags = const [], this.localFlags = const []});
}

class WizResult {
  late String msg;
  late LogType logType;

  WizResult(this.logType, this.msg);

  WizResult.success(String? completionMsg) {
    logType = LogType.log;
    msg = completionMsg ?? 'done';
  }

  WizResult.commandNotFound(Command cmd) {
    logType = LogType.err;
    msg =
        "The command root '${cmd.root}' does not have a CommandHandler defined.";
  }
}

class WizEngine {
  static Future<WizResult> handle(String raw) async =>
      Interpreter(Environment()).interpret(
        Parser(
          Tokeniser(raw).tokenise(),
        ).parse(),
      );
}

class Environment {
  final List<Permission> permissions;

  Environment([this.permissions = const []]);
}

class Permission {}

extension StringUtils on String {
  String indent(int indent) => "|" + ("-" * indent) + this;
  String newline(String text) => this + "\n" + text;
  bool get isNewline => (this == '\n');
  bool get isEOF => (this == 'EOF');
  bool get isAlphaNum => (<String>[
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '_'
      ].contains(this));

  bool get isAlpha => (<String>[
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
        '_'
      ].contains(this));

  String charAt(int pos) => this[pos];
}
