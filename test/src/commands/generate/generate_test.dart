import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/generate/generate.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  '(Re-)Generates code and files in an existing Scalable project.\n'
      '\n'
      'Usage: scalable generate <target>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  assets         scalable generate assets\n'
      '                 (Re-)Generates the assets of this project.\n'
      '  code           scalable generate code\n'
      '                 (Re-)Generates the code of this project.\n'
      '  localization   scalable generate localization\n'
      '                 (Re-)Generates the localizations of this project.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('generate', () {
    test('gen is a valid alias', () {
      final command = GenerateCommand();
      expect(command.aliases, contains('gen'));
    });

    test('g is a valid alias', () {
      final command = GenerateCommand();
      expect(command.aliases, contains('g'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['generate', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['generate', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = GenerateCommand();
      expect(command, isNotNull);
    });
  });
}
