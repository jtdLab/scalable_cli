import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/commands.dart';
import 'package:scalable_cli/src/commands/core/generator_builder.dart';
import 'package:scalable_cli/src/commands/enable/commands/commands.dart';

/// {@template enable_command}
/// `scalable enable` command adds support for a platform to an existing Scalable project.
/// {@endtemplate}
class EnableCommand extends ScalableCommand {
  /// {@macro enable_command}
  EnableCommand({
    Logger? logger,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          command: Command.enable,
        ) {
    addSubcommand(AndroidCommand(logger: logger, generator: generator));
    addSubcommand(IosCommand(logger: logger, generator: generator));
    addSubcommand(WebCommand(logger: logger, generator: generator));
    addSubcommand(LinuxCommand(logger: logger, generator: generator));
    addSubcommand(MacosCommand(logger: logger, generator: generator));
    addSubcommand(WindowsCommand(logger: logger, generator: generator));
  }

  @override
  String get description =>
      'Adds support for a platform to an existing Scalable project.';

  @override
  String get invocation => '${super.invocation} <platform>';

  @override
  List<String> get aliases => ['e'];
}
