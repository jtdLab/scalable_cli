import 'dart:math';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:scalable_cli/src/cli/cli.dart';
import 'package:scalable_cli/src/commands/commands.dart';
import 'package:scalable_cli/src/commands/core/overridable_arg_results.dart';
import 'package:universal_io/io.dart';

// TODO impl scalable like  atm just copied from vgv

/// Signature for the [Flutter.installed] method.
typedef FlutterInstalledCommand = Future<bool> Function();

/// Signature for the [Flutter.test] method.
typedef FlutterTestCommand = Future<List<int>> Function({
  String cwd,
  bool recursive,
  bool collectCoverage,
  bool optimizePerformance,
  double? minCoverage,
  String? excludeFromCoverage,
  String? randomSeed,
  List<String>? arguments,
  Logger? logger,
  void Function(String)? stdout,
  void Function(String)? stderr,
});

/// {@template test_command}
/// `scalable test` command runs test in an existing scalable project.
/// {@endtemplate}
class TestCommand extends ScalableCommand with OverridableArgResults {
  /// {@macro test_command}
  TestCommand({
    Logger? logger,
    FlutterInstalledCommand? flutterInstalled,
    FlutterTestCommand? flutterTest,
  })  : _flutterInstalled = flutterInstalled ?? Flutter.installed,
        _flutterTest = flutterTest ?? Flutter.test,
        super(
          logger: logger ?? Logger(),
          command: Command.test,
        ) {
    argParser
      ..addFlag(
        'coverage',
        help: 'Whether to collect coverage information.',
        negatable: false,
      )
      ..addFlag(
        'recursive',
        abbr: 'r',
        help: 'Run tests recursively for all nested packages.',
        negatable: false,
      )
      ..addFlag(
        'optimization',
        defaultsTo: true,
        help: 'Whether to apply optimizations for test performance.',
      )
      ..addOption(
        'concurrency',
        abbr: 'j',
        defaultsTo: '4',
        help: 'The number of concurrent test suites run.',
      )
      ..addOption(
        'tags',
        abbr: 't',
        help: 'Run only tests associated with the specified tags.',
      )
      ..addOption(
        'exclude-coverage',
        help: 'A glob which will be used to exclude files that match from the '
            'coverage.',
      )
      ..addOption(
        'exclude-tags',
        abbr: 'x',
        help: 'Run only tests that do not have the specified tags.',
      )
      ..addOption(
        'min-coverage',
        help: 'Whether to enforce a minimum coverage percentage.',
      )
      ..addOption(
        'test-randomize-ordering-seed',
        help: 'The seed to randomize the execution order of test cases '
            'within test files.',
      )
      ..addFlag(
        'update-goldens',
        help: 'Whether "matchesGoldenFile()" calls within your test methods '
            'should update the golden files.',
        negatable: false,
      );
  }

  final FlutterInstalledCommand _flutterInstalled;
  final FlutterTestCommand _flutterTest;

  @override
  String get description => 'Runs tests in an existing Scalable project.';

  @override
  Future<int> run() async {
    final targetPath = path.normalize(Directory.current.absolute.path);
    final pubspec = File(path.join(targetPath, 'pubspec.yaml'));

    if (!pubspec.existsSync()) {
      logger.err(
        '''
Could not find a pubspec.yaml in $targetPath.
This command should be run from the root of your Flutter project.''',
      );
      return ExitCode.noInput.code;
    }

    final concurrency = argResults['concurrency'] as String;
    final recursive = argResults['recursive'] as bool;
    final collectCoverage = argResults['coverage'] as bool;
    final minCoverage = double.tryParse(
      argResults['min-coverage'] as String? ?? '',
    );
    final excludeTags = argResults['exclude-tags'] as String?;
    final tags = argResults['tags'] as String?;
    final isFlutterInstalled = await _flutterInstalled();
    final excludeFromCoverage = argResults['exclude-coverage'] as String?;
    final randomOrderingSeed =
        argResults['test-randomize-ordering-seed'] as String?;
    final randomSeed = randomOrderingSeed == 'random'
        ? Random().nextInt(4294967295).toString()
        : randomOrderingSeed;
    final optimizePerformance = argResults['optimization'] as bool;
    final updateGoldens = argResults['update-goldens'] as bool;

    if (isFlutterInstalled) {
      try {
        final results = await _flutterTest(
          optimizePerformance:
              optimizePerformance && argResults.rest.isEmpty && !updateGoldens,
          recursive: recursive,
          logger: logger,
          stdout: logger.write,
          stderr: logger.err,
          collectCoverage: collectCoverage || minCoverage != null,
          minCoverage: minCoverage,
          excludeFromCoverage: excludeFromCoverage,
          randomSeed: randomSeed,
          arguments: [
            if (excludeTags != null) ...['-x', excludeTags],
            if (tags != null) ...['-t', tags],
            if (updateGoldens) '--update-goldens',
            ...['-j', concurrency],
            '--no-pub',
            ...argResults.rest,
          ],
        );
        if (results.any((code) => code != ExitCode.success.code)) {
          return ExitCode.unavailable.code;
        }
      } on MinCoverageNotMet catch (e) {
        logger.err(
          '''Expected coverage >= ${minCoverage!.toStringAsFixed(2)}% but actual is ${e.coverage.toStringAsFixed(2)}%.''',
        );
        return ExitCode.unavailable.code;
      } catch (error) {
        logger.err('$error');
        return ExitCode.unavailable.code;
      }
    }
    return ExitCode.success.code;
  }
}
