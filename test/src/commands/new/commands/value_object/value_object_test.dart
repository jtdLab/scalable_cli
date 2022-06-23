import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds new value object + tests to this project.\n'
      '\n'
      'Usage: scalable new valueObject\n'
      '-h, --help          Print this usage information.\n'
      '-o, --output-dir    The output directory inside lib/domain/.\n'
      '                    (defaults to "")\n'
      '\n'
      '\n'
      '    --type          The type that gets wrapped by this value object.\n'
      '                    Generics get escaped via "#" e.g Tuple<#A, #B, String>.\n'
      '                    (defaults to "MyType")\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('valueObject', () {
    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result =
            await commandRunner.run(['new', 'valueObject', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr =
            await commandRunner.run(['new', 'valueObject', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = ValueObjectCommand();
      expect(command, isNotNull);
    });
  });
}
