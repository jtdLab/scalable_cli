import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:pub_updater/pub_updater.dart';
import 'package:scalable_cli/src/commands/commands.dart';
import 'package:scalable_cli/src/commands/test/test.dart';
import 'package:scalable_cli/src/version.dart';

/// The package name.
const _packageName = 'scalable_cli';

/// {@template scalable_command_runner}
/// A [CommandRunner] for the Scalable CLI.
/// {@endtemplate}
class ScalableCommandRunner extends CommandRunner<int> {
  /// {@macro scalable_command_runner}
  ScalableCommandRunner({
    Logger? logger,
    PubUpdater? pubUpdater,
  })  : _logger = logger ?? Logger(),
        _pubUpdater = pubUpdater ?? PubUpdater(),
        super('scalable', 'Scalable Command Line Interface') {
    argParser.addFlag(
      'version',
      abbr: 'v',
      help: 'Print the current version.',
      negatable: false,
    );
    addCommand(CreateCommand(logger: logger));
    addCommand(NewCommand(logger: logger));
    addCommand(EnableCommand(logger: logger));
    addCommand(GenerateCommand(logger: logger));
    addCommand(TestCommand(logger: logger));
  }

  final Logger _logger;
  final PubUpdater _pubUpdater;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
      return await runCommand(argResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    int? exitCode = ExitCode.unavailable.code;
    if (topLevelResults['version']) {
      _logger.info(packageVersion);
      exitCode = ExitCode.success.code;
    } else {
      exitCode = await super.runCommand(topLevelResults);
    }
    await _checkForUpdates();
    return exitCode;
  }

  Future<void> _checkForUpdates() async {
    try {
      final latestVersion = await _pubUpdater.getLatestVersion(_packageName);
      final isUpToDate = packageVersion == latestVersion;

      if (!isUpToDate) {
        _logger
          ..info('')
          ..info(
            '''
${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(latestVersion)}
Run ${lightCyan.wrap('dart pub global activate scalable_cli')} to update''',
          );
      }
    } catch (_) {}
  }
}
