import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds new data transfer object + tests to this project.\n'
      '\n'
      'Usage: scalable new dto\n'
      '-h, --help          Print this usage information.\n'
      '-o, --output-dir    The output directory inside lib/infrastructure/.\n'
      '                    (defaults to "")\n'
      '\n'
      '\n'
      '-e, --entity        The entity this dto belongs to.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('dto', () {
    test('d is a valid alias', () {
      final command = DtoCommand();
      expect(command.aliases, contains('d'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['new', 'dto', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['new', 'dto', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = DtoCommand();
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // TODO
    });
  });
}
