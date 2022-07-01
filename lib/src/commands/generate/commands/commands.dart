import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:scalable_cli/src/cli/cli.dart';
import 'package:scalable_cli/src/commands/core/logging.dart';
import 'package:scalable_cli/src/commands/core/pubspec_required.dart';
import 'package:scalable_cli/src/core/assets_file.dart';
import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:scalable_cli/src/core/project.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/router_gr_file.dart';

part 'assets/assets.dart';
part 'code/code.dart';
part 'localization/localization.dart';

// TODO naming target seems not right

// TODO doc
enum Target { assets, code, localization }

/// {@template target_command}
/// Base class for all generate sub commands.
/// {@endtemplate}
abstract class TargetCommand extends Command<int>
    with Logging, PubspecRequired {
  /// {@macro target_command}
  TargetCommand({
    required this.logger,
    required this.target,
  });

  @override
  final Logger logger;
  final Target target;

  @override
  String get summary => '$invocation\n$description';

  @override
  String get name => target.name;

  @override
  String get invocation => 'scalable generate $name';
}
