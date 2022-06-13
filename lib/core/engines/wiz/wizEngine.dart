part of wiz;

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

  @override
  String toString() =>
      "'$lexeme': $tokenType ${literal ?? ''} [$lineNo:$start]";
}

class Parser {
  final List<Token> tokens;
  Parser(this.tokens);

  Command parse() => const Command(
        'test',
        <String>[],
        Args(
          positionalArgs: <String>['hello'],
        ),
        Flags(),
      );
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
