import '../wiz.dart';

void main() {
  const String src = """wiz.create.proj "aaa" "bbb" val: true; --F -V""";
  final Tokeniser tokeniser = Tokeniser(src);
  tokeniser.tokenise();
  final Parser parser = Parser(tokeniser.tokens);
  final Command command = parser.parse();
  final Environment environment = Environment();
  final Interpreter interpreter = Interpreter(environment);
  interpreter.interpret(command);
}
