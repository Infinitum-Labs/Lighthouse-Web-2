import '../context.dart';

void main(List<String> args) {
  final Context context = Context(
    'x',
    ConstrainedNum(1, 3),
    const Duration(hours: 1),
    Resources([
      Resource('a'),
      Resource('b'),
    ], null),
  );
  final ContextRequirement requirement = ContextRequirement(
    ["home", "office"],
    ConstrainedNum(3, 5),
    const Duration(hours: 3),
    Resources([
      Resource('a'),
      Resource('b'),
      Resource('c'),
    ], null),
    Weightage(0.3, 0.1, 0.3, 0.3),
  );
  print(
      ContextEngine(ContextEngineConfiguration()).match(requirement, context));
}
