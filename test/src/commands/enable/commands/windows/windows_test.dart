import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/enable/commands/commands.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds support for Windows to this project.\n'
      '\n'
      'Usage: scalable enable windows\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the Windows project.\n'
      '                  (defaults to "com.example")\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('windows', () {
    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['enable', 'windows', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['enable', 'windows', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = WindowsCommand();
      expect(command, isNotNull);
    });
  });
}
