import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/generate/commands/commands.dart';
import 'package:scalable_cli/src/core/assets_file.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';

import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  '(Re-)Generates the assets of this project.\n'
      '\n'
      'Usage: scalable generate assets\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockAssetsFile extends Mock implements AssetsFile {}

void main() {
  group('assets', () {
    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;

    setUp(() {
      progressLogs = <String>[];

      logger = MockLogger();
      progress = MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result =
            await commandRunner.run(['generate', 'assets', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr =
            await commandRunner.run(['generate', 'assets', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = AssetsCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final result = await commandRunner.run(['generate', 'assets']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      final pubspec = MockPubspecFile();
      final assetsFile = MockAssetsFile();
      final command = AssetsCommand(
        logger: logger,
        pubspec: pubspec,
        assets: assetsFile,
      );
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.updateFlutterAssets()).thenReturn(null);
      when(() => pubspec.updateFlutterFonts()).thenReturn(null);
      when(() => assetsFile.generate()).thenReturn(null);
      final result = await command.run();
      verify(() => logger.progress('Generating assets'));
      verify(() => pubspec.updateFlutterAssets()).called(1);
      verify(() => pubspec.updateFlutterFonts()).called(1);
      verify(() => assetsFile.generate()).called(1);
      expect(progressLogs, ['Generated assets']);
      expect(result, ExitCode.success.code);
    });
  });
}
