import 'package:args/command_runner.dart' as runner;
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:scalable_cli/src/commands/core/logging.dart';

export 'create/create.dart';
export 'enable/enable.dart';
export 'generate/generate.dart';
export 'new/new.dart';

// TODO doc
enum Command {
  create,
  enable,
  generate,
  new_,
  test;

  String get name => toString().split('.').last.replaceAll('_', '');
}

/// {@template scalable_command}
/// Base class for all scalable commands.
/// {@endtemplate}
abstract class ScalableCommand extends runner.Command<int> with Logging {
  /// {@macro scalable_command}
  ScalableCommand({
    required this.logger,
    required this.command,
  });

  @override
  final Logger logger;
  final Command command;

  @override
  String get summary => '$invocation\n$description';

  @override
  String get name => command.name;

  @mustCallSuper
  @override
  String get invocation => 'scalable $name';
}
