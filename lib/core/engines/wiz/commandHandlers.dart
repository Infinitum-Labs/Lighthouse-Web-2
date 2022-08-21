part of core.engines.wiz;

abstract class CommandHandler {
  WizResult handle(Command cmd);
}

class _Test implements CommandHandler {
  const _Test();
  @override
  WizResult handle(Command cmd) =>
      WizResult.success(cmd.args.positionalArgs.first);
}
