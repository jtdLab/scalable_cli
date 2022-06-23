import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/generate/commands/commands.dart';

import 'package:test/test.dart';

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

void main() {
  group('localization', () {
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
  });
}
