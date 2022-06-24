import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/enable/commands/commands.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds support for macOS to this project.\n'
      '\n'
      'Usage: scalable enable macos\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the macOS project.\n'
      '                  (defaults to "com.example")\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('macos', () {
    test('m is a valid alias', () {
      final command = MacosCommand();
      expect(command.aliases, contains('m'));
    });

    test('mac is a valid alias', () {
      final command = MacosCommand();
      expect(command.aliases, contains('mac'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['enable', 'macos', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['enable', 'macos', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = MacosCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final directory = Directory.systemTemp.createTempSync();
        Directory.current = directory.path;
        final result = await commandRunner.run(['enable', 'macos']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    test('completes successfully with correct output', () {
      // TODO
    });

    test('exits with 78 when macos is already enabled', () {
      // TODO
    });
  });
}
