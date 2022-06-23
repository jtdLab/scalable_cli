import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/new/new.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds a new component to an existing Scalable project.\n'
      '\n'
      'Usage: scalable new <component>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  bloc          scalable new bloc\n'
      '                Adds new bloc + tests to this project.\n'
      '  cubit         scalable new cubit\n'
      '                Adds new cubit + tests to this project.\n'
      '  dto           scalable new dto\n'
      '                Adds new data transfer object + tests to this project.\n'
      '  entity        scalable new entity\n'
      '                Adds new entity + tests to this project.\n'
      '  flow          scalable new flow\n'
      '                Adds new flow + tests to this project.\n'
      '  page          scalable new page\n'
      '                Adds new page + tests to this project.\n'
      '  service       scalable new service\n'
      '                Adds new service + tests to this project.\n'
      '  valueObject   scalable new valueObject\n'
      '                Adds new value object + tests to this project.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('enable', () {
    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['new', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['new', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = NewCommand();
      expect(command, isNotNull);
    });
  });
}
