import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/enable/enable.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds support for a platform to an existing Scalable project.\n'
      '\n'
      'Usage: scalable enable <platform>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  android   scalable enable android\n'
      '            Adds support for Android to this project.\n'
      '  ios       scalable enable ios\n'
      '            Adds support for iOS to this project.\n'
      '  linux     scalable enable linux\n'
      '            Adds support for Linux to this project.\n'
      '  macos     scalable enable macos\n'
      '            Adds support for macOS to this project.\n'
      '  web       scalable enable web\n'
      '            Adds support for Web to this project.\n'
      '  windows   scalable enable windows\n'
      '            Adds support for Windows to this project.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

void main() {
  group('enable', () {
    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['enable', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['enable', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = EnableCommand();
      expect(command, isNotNull);
    });
  });
}
