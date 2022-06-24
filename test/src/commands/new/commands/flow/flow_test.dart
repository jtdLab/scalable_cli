import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds new flow + tests to this project.\n'
      '\n'
      'Usage: scalable new flow\n'
      '-h, --help          Print this usage information.\n'
      '-o, --output-dir    The output directory inside lib/presentation/**/ (** is the platform).\n'
      '                    (defaults to "")\n'
      '\n'
      '\n'
      '    --mobile        The flow gets generated for Android and iOS.\n'
      '    --desktop       The flow gets generated for Linux, macOS and Windows.\n'
      '    --android       The flow gets generated for the Android platform.\n'
      '    --ios           The flow gets generated for the iOS platform.\n'
      '    --web           The flow gets generated for the Web platform.\n'
      '    --linux         The flow gets generated for the Linux platform.\n'
      '    --macos         The flow gets generated for the macOS platform.\n'
      '    --windows       The flow gets generated for the Windows platform.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('flow', () {
    test('f is a valid alias', () {
      final command = FlowCommand();
      expect(command.aliases, contains('f'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['new', 'flow', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['new', 'flow', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = FlowCommand();
      expect(command, isNotNull);
    });
  });
}
