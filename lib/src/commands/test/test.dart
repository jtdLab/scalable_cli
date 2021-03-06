import 'dart:math';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:scalable_cli/src/cli/cli.dart';
import 'package:scalable_cli/src/commands/commands.dart';
import 'package:scalable_cli/src/commands/core/overridable_arg_results.dart';
import 'package:scalable_cli/src/commands/core/pubspec_required.dart';
import 'package:scalable_cli/src/core/project.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';

/// Gets params from [ArgResults] specified by the user.
extension ParamsFromArgResults on ArgResults {
  bool get coverage => this['coverage'];
  bool get recursive => this['recursive'];
  bool get optimization => this['optimization'];
  String get concurrency => this['concurrency'];
  String? get tags => this['tags'];
  String? get excludeCoverage => this['exclude-coverage'];
  String? get excludeTags => this['exclude-tags'];
  String? get minCoverage => this['min-coverage'];
  String? get testRandomizeOrderingSeed => this['test-randomize-ordering-seed'];
  bool get updateGoldens => this['update-goldens'];
}

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
class TestCommand extends ScalableCommand
    with OverridableArgResults, PubspecRequired {
  /// {@macro test_command}
  TestCommand({
    Logger? logger,
    PubspecFile? pubspec,
    FlutterInstalledCommand? flutterInstalled,
    FlutterTestCommand? flutterTest,
  })  : pubspec = pubspec ?? Project.pubspec,
        _flutterInstalled = flutterInstalled ?? Flutter.installed,
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

  @override
  final PubspecFile pubspec;

  final FlutterInstalledCommand _flutterInstalled;
  final FlutterTestCommand _flutterTest;

  @override
  String get description => 'Runs tests in an existing Scalable project.';

  @override
  Future<int> run() => runWhenPubspecExists(() async {
        final concurrency = argResults.concurrency;
        final recursive = argResults.recursive;
        final collectCoverage = argResults.coverage;
        final minCoverage = double.tryParse(argResults.minCoverage ?? '');
        final excludeTags = argResults.excludeTags;
        final tags = argResults.tags;
        final isFlutterInstalled = await _flutterInstalled();
        final excludeFromCoverage = argResults.excludeCoverage;
        final randomOrderingSeed = argResults.testRandomizeOrderingSeed;
        final randomSeed = randomOrderingSeed == 'random'
            ? Random().nextInt(4294967295).toString()
            : randomOrderingSeed;
        final optimizePerformance = argResults.optimization;
        final updateGoldens = argResults.updateGoldens;

        if (isFlutterInstalled) {
          try {
            final results = await _flutterTest(
              optimizePerformance: optimizePerformance &&
                  argResults.rest.isEmpty &&
                  !updateGoldens,
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
      });
}
