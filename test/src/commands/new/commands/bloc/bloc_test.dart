import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds new bloc + tests to this project.\n'
      '\n'
      'Usage: scalable new bloc\n'
      '-h, --help          Print this usage information.\n'
      '-o, --output-dir    The output directory inside lib/application/.\n'
      '                    (defaults to "")\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('bloc', () {
    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['new', 'bloc', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['new', 'bloc', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = BlocCommand();
      expect(command, isNotNull);
    });
  });
}
