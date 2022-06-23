import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/commands.dart';
import 'package:scalable_cli/src/commands/core/generator_builder.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';

/// {@template new_command}
/// `scalable new` command adds a new component to an existing Scalable project.
/// {@endtemplate}
class NewCommand extends ScalableCommand {
  /// {@macro new_command}
  NewCommand({
    Logger? logger,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          command: Command.new_,
        ) {
    addSubcommand(PageCommand(logger: logger, generator: generator));
    addSubcommand(FlowCommand(logger: logger, generator: generator));
    addSubcommand(BlocCommand(logger: logger, generator: generator));
    addSubcommand(CubitCommand(logger: logger, generator: generator));
    addSubcommand(EntityCommand(logger: logger, generator: generator));
    addSubcommand(ValueObjectCommand(logger: logger, generator: generator));
    addSubcommand(ServiceCommand(logger: logger, generator: generator));
    addSubcommand(DtoCommand(logger: logger, generator: generator));
  }

  @override
  String get description =>
      'Adds a new component to an existing Scalable project.';

  @override
  String get invocation => '${super.invocation} <component>';

  @override
  List<String> get aliases => ['n'];
}
