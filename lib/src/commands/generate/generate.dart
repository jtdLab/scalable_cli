import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/commands.dart';
import 'package:scalable_cli/src/commands/core/generator_builder.dart';
import 'package:scalable_cli/src/commands/generate/commands/commands.dart';

/// {@template generate_command}
/// `scalable generate` command (re-)generates code and files in an existing Scalable project.
/// {@endtemplate}
class GenerateCommand extends ScalableCommand {
  /// {@macro generate_command}
  GenerateCommand({
    Logger? logger,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          command: Command.generate,
        ) {
    addSubcommand(AssetsCommand(logger: logger));
    addSubcommand(CodeCommand(logger: logger));
    addSubcommand(LocalizationCommand(logger: logger));
  }

  @override
  String get description =>
      '(Re-)Generates code and files in an existing Scalable project.';

  @override
  String get invocation => '${super.invocation} <target>';

  @override
  List<String> get aliases => ['gen', 'g'];
}
