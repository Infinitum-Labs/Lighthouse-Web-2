enum LogType {
  log,
  warn,
  info,
  err,
}

abstract class CommandHandler {
  WizResult handle(Command cmd);
}

class _Test implements CommandHandler {
  const _Test();
  @override
  WizResult handle(Command cmd) =>
      WizResult.success(cmd.args.positionalArgs.first);
}

class Command {
  final String root;
  final List<String> subcommands;
  final Args args;
  final Flags flags;

  const Command(this.root, this.subcommands, this.args, this.flags);
}

class Args {
  final List<String> positionalArgs;
  final Map<String, String> namedArgs;

  const Args({this.positionalArgs = const [], this.namedArgs = const {}});
}

class Flags {
  final Map<String, String> globalFlags;
  final Map<String, String> localFlags;

  const Flags({this.globalFlags = const {}, this.localFlags = const {}});
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

enum TokenType {
  identifier,
  string,
  quotes,
  colon,
  semicolon,
  dot,
  minus,
  minus_minus,
  eof,
}

class WizEngine {
  static Future<WizResult> handle(String raw) async => Interpreter().interpret(
        Parser(
          Tokeniser(raw).tokenise(),
        ).parse(),
      );
}

class Tokeniser {
  final String source;
  final List<String> lines = [];
  final List<Token> tokens = [];
  int start = 0;
  int current = 0;
  int lineNo = 0;

  Tokeniser(this.source) {
    lines.addAll(source.split('\n'));
  }

  List<Token> tokenise() {
    while (!atEnd) {
      start = current;
      scanToken();
    }
    tokens.add(
      Token(
        TokenType.eof,
        '',
        lineNo: source.split('\n').length,
        start: 0,
      ),
    );
    return tokens;
  }

  void scanToken() {
    String c = advance();
    switch (c) {
      case '.':
        addToken(TokenType.dot);
        break;
      case '-':
        if (match('-')) {
          addToken(TokenType.minus_minus);
        } else {
          addToken(TokenType.minus);
        }
        break;
      case ';':
        addToken(TokenType.semicolon);
        break;
      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace.
        break;
      case '\n':
        lineNo++;
        break;
      case '"':
      case "'":
        tokeniseString(c);
        break;
      default:
        if (c.isAlpha) {
          tokeniseIdentifier();
        } else {
          /* ErrorHandler.issues.add(
            Issue(
              IssueType.SyntaxError,
              IssueTitle.unexpectedChar(c),
              lineNo: lineNo,
              start: current,
              offendingLine: lines[lineNo],
              description: "Tokeniser could not produce a token for: $c. It may be an illegal character in the given context.",
            ),
          ); */
        }
        break;
    }
  }

  void addToken(TokenType tokenType, [Object? literal]) {
    tokens.add(
      Token(
        tokenType,
        source.substring(start, current),
        lineNo: lineNo,
        start: start,
        literal: literal,
      ),
    );
  }

  String advance() {
    return source.charAt(current++);
  }

  bool match(String expected) {
    if (atEnd) return false;
    if (source.charAt(current) != expected) return false;

    current++;
    return true;
  }

  String peek([int lookaheadCount = 0]) {
    if (current + lookaheadCount >= source.length) return 'EOF';
    return source.charAt(current + lookaheadCount);
  }

  void tokeniseString(String delimiter) {
    while (peek() != delimiter && !atEnd) {
      if (peek() == '\n') lineNo++;
      advance();
    }

    if (atEnd) {
      // unterminated string error
      /* ErrorHandler.issues.add(
        Issue(
          IssueType.SyntaxError,
          IssueTitle.unterminatedPair(delimiter),
          lineNo: lineNo,
          start: start,
          offendingLine: lines[lineNo],
          description: 'Unterminated string literal.',
        ),
      ); */
      return;
    }

    advance();

    String value = source.substring(start + 1, current - 1);
    addToken(TokenType.string, value);
  }

  void tokeniseIdentifier() {
    while (peek().isAlphaNum) {
      advance();
    }
    String text = source.substring(start, current);
    addToken(TokenType.identifier);
  }

  bool get atEnd => !(current < source.length);
}

class Token {
  final TokenType tokenType;
  final String lexeme;
  final Object? literal;
  final int lineNo;
  final int start;

  Token(
    this.tokenType,
    this.lexeme, {
    required this.lineNo,
    required this.start,
    this.literal,
  });

  bool get isEOF => tokenType == TokenType.eof;

  @override
  String toString() =>
      "'$lexeme': $tokenType ${literal ?? ''} [$lineNo:$start]";
}

class Parser {
  final List<Token> tokens;
  int cursor = 0;
  late Token root;
  final List<Token> subcommands = [];
  final List<Token> posArgs = [];
  final Map<String, List<Token>> namedArgs = {};
  final List<Token> lFlags = [];
  final List<Token> gFlags = [];
  Parser(this.tokens);

  Command parse() {
    if (tokens.isEmpty) throw Exception("EMPTY COMMAND");
    root = consume(TokenType.identifier);
    while (match([TokenType.identifier])) {
      subcommands.add(previous());
    }
    while (match([TokenType.string])) {
      posArgs.add(previous());
    }
    parseNamedArgsOrFlags();

    print([root, subcommands, namedArgs, posArgs, lFlags, gFlags].join('\n\n'));
    return const Command(
      'test',
      <String>[],
      Args(
        positionalArgs: <String>['hello'],
      ),
      Flags(),
    );
  }

  void parseNamedArgsOrFlags() {
    while (
        ![TokenType.minus, TokenType.minus_minus].contains(peek().tokenType)) {
      namedArgs[consume(TokenType.identifier).lexeme] = parseNamedArg();
    }
    while (!match([TokenType.eof])) {
      if (match([TokenType.minus])) {
        lFlags.add(parseFlag());
      } else if (match([TokenType.minus_minus])) {
        gFlags.add(parseFlag());
      } else {
        parseNamedArgsOrFlags();
      }
    }
  }

  Token parseFlag() {
    if (match([TokenType.identifier])) return previous();
    throw Exception("flag name must be an identifier");
  }

  List<Token> parseNamedArg() {
    final List<Token> args = [];
    consume(TokenType.colon);
    while (!match([TokenType.semicolon])) {
      if (match([TokenType.identifier]) || match([TokenType.string])) {
        args.add(previous());
      } else {
        if (peek().tokenType == TokenType.minus ||
            peek().tokenType == TokenType.colon) {
          throw Exception("Terminate named arguments with ';'");
        } else {
          throw Exception(
              "Pass either identifier or string as argument: ${consume(previous().tokenType).lexeme}");
        }
      }
    }
    return args;
  }

  Token previous() => tokens[cursor - 1];

  bool match(List<TokenType> types) {
    if (types.contains(peek().tokenType)) {
      consume(peek().tokenType);
      return true;
    } else {
      return false;
    }
  }

  Token peek([int lookahead = 0]) {
    if (cursor + lookahead < tokens.length) {
      return tokens[cursor + lookahead];
    } else {
      return Token(TokenType.eof, 'EOF', lineNo: 0, start: 0);
    }
  }

  Token consume(TokenType type) => cursor == tokens.length
      ? throw Exception("$type expected")
      : tokens[cursor++];
}

class Interpreter {
  // final Environment environment;
  Interpreter();

  WizResult interpret(Command cmd) {
    // should be loaded from DB
    final Map<String, CommandHandler> commandHandlers = {
      'test': const _Test(),
    };
    if (commandHandlers.containsKey(cmd.root))
      return commandHandlers[cmd.root]!.handle(cmd);
    return WizResult.commandNotFound(cmd);
  }
}

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

// create proj "My Amazing Project"
// a: a1;
// b: b1;
// --G
// -L

void main() {
  final String src = """wiz create proj \"aaa\" \"bbb\" val:true; --F -V""";
  (Parser(Tokeniser(src).tokenise()).parse());
}
