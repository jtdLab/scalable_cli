import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';
import 'package:test/test.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds new page + tests to this project.\n'
      '\n'
      'Usage: scalable new page\n'
      '-h, --help            Print this usage information.\n'
      '-o, --output-dir      The output directory inside lib/presentation/**/ (** is the platform).\n'
      '                      (defaults to "")\n'
      '\n'
      '\n'
      '    --mobile          The page gets generated for Android and iOS.\n'
      '    --desktop         The page gets generated for Linux, macOS and Windows.\n'
      '    --android         The page gets generated for the Android platform.\n'
      '    --ios             The page gets generated for the iOS platform.\n'
      '    --web             The page gets generated for the Web platform.\n'
      '    --linux           The page gets generated for the Linux platform.\n'
      '    --macos           The page gets generated for the macOS platform.\n'
      '    --windows         The page gets generated for the Windows platform.\n'
      '\n'
      '\n'
      '    --[no-]widgets    Generate separate widgets.dart file for the page.\n'
      '                      (defaults to on)\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('page', () {
    test('p is a valid alias', () {
      final command = PageCommand();
      expect(command.aliases, contains('p'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['new', 'page', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['new', 'page', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = PageCommand();
      expect(command, isNotNull);
    });
  });
}
