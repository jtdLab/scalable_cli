import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/enable/commands/commands.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds support for Android to this project.\n'
      '\n'
      'Usage: scalable enable android\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the Android project.\n'
      '                  (defaults to "com.example")\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('android', () {
    final cwd = Directory.current;

    setUp(() {
      Directory.current = cwd;
    });

    test('a is a valid alias', () {
      final command = AndroidCommand();
      expect(command.aliases, contains('a'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['enable', 'android', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['enable', 'android', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = AndroidCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final directory = Directory.systemTemp.createTempSync();
        Directory.current = directory.path;
        final result = await commandRunner.run(['enable', 'android']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    test('completes successfully with correct output', () {
      // TODO
    });

    test('exits with 78 when android is already enabled', () {
      // TODO
    });
  });
}
