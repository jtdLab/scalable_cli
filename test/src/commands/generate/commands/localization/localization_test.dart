import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/generate/commands/commands.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';

import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  '(Re-)Generates the localizations of this project.\n'
      '\n'
      'Usage: scalable generate localization\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

// ignore: one_member_abstracts
abstract class FlutterGenL10nCommand {
  Future<void> call({String cwd});
}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockFlutterGenL10nCommand extends Mock implements FlutterGenL10nCommand {}

void main() {
  group('localization', () {
    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;

    late FlutterGenL10nCommand flutterGenL10nCommand;

    setUp(() {
      progressLogs = <String>[];

      logger = MockLogger();
      progress = MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      flutterGenL10nCommand = MockFlutterGenL10nCommand();
      when(() => flutterGenL10nCommand(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result =
            await commandRunner.run(['generate', 'localization', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr =
            await commandRunner.run(['generate', 'localization', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = LocalizationCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final directory = Directory.systemTemp.createTempSync();
        Directory.current = directory.path;
        final result = await commandRunner.run(['generate', 'localization']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      final pubspec = MockPubspecFile();
      final command = LocalizationCommand(
        logger: logger,
        pubspec: pubspec,
        flutterGenl10n: flutterGenL10nCommand,
      );
      when(() => pubspec.exists).thenReturn(true);
      final result = await command.run();
      verify(() => logger.progress('Generating localization'));
      verify(() => flutterGenL10nCommand()).called(1);
      expect(progressLogs, ['Generated localization']);
      expect(result, ExitCode.success.code);
    });
  });
}
