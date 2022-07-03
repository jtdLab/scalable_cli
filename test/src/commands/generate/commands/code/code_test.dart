import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/generate/commands/commands.dart';
import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/router_gr_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  '(Re-)Generates the code of this project.\n'
      '\n'
      'Usage: scalable generate code\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

// ignore: one_member_abstracts
abstract class FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({String cwd});
}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

class MockInjectionConfigFile extends Mock implements InjectionConfigFile {}

class MockRouterGrFile extends Mock implements RouterGrFile {}

void main() {
  group('code', () {
    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;

    late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand;

    setUp(() {
      progressLogs = <String>[];

      logger = MockLogger();
      progress = MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      flutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand =
          MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
      when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand(
          cwd: any(named: 'cwd'))).thenAnswer((_) async {});
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['generate', 'code', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['generate', 'code', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = CodeCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final result = await commandRunner.run(['generate', 'code']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      final pubspec = MockPubspecFile();
      final injectionConfig = MockInjectionConfigFile();
      final routerGr1 = MockRouterGrFile();
      final routerGr2 = MockRouterGrFile();
      final command = CodeCommand(
        logger: logger,
        pubspec: pubspec,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand,
        injectionConfig: injectionConfig,
        routerGrs: {routerGr1, routerGr2},
      );

      when(() => pubspec.exists).thenReturn(true);
      when(() => injectionConfig.addCoverageIgnoreFile()).thenReturn(null);
      when(() => routerGr1.addCoverageIgnoreFile()).thenReturn(null);
      when(() => routerGr2.addCoverageIgnoreFile()).thenReturn(null);
      final result = await command.run();
      verify(() => logger.progress('Generating code'));
      verify(
        () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand(),
      ).called(1);
      verify(() => injectionConfig.addCoverageIgnoreFile()).called(1);
      verify(() => routerGr1.addCoverageIgnoreFile()).called(1);
      verify(() => routerGr2.addCoverageIgnoreFile()).called(1);
      expect(progressLogs, ['Generated code']);
      expect(result, ExitCode.success.code);
    });
  });
}
