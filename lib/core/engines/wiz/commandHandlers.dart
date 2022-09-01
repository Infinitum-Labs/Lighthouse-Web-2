part of core.engines.wiz;

abstract class CommandHandler {
  final Environment environment;

  const CommandHandler(this.environment);

  WizResult handle(Command cmd);
}

class _Test extends CommandHandler {
  const _Test(super.environment);

  @override
  WizResult handle(Command cmd) =>
      WizResult.success(cmd.args.positionalArgs.first.lexeme);
}
