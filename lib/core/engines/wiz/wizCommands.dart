part of wiz;

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
