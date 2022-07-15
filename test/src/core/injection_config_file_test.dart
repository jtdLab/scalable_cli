import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

void main() {
  group('InjectionConfigFile', () {
    final cwd = Directory.current;

    setUp(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is "lib/core/injection.config.dart"', () {
        final injectionConfigFile = InjectionConfigFile();
        expect(
          injectionConfigFile.path,
          'lib/core/injection.config.dart',
        );
      });
    });

    group('file', () {
      test('has path "lib/core/injection.config.dart"', () {
        final injectionConfigFile = InjectionConfigFile();
        expect(
          injectionConfigFile.file.path,
          'lib/core/injection.config.dart',
        );
      });
    });

    group('addCoverageIgnoreFile', () {
      const content = '''
abc
def
ghi
''';

      test('adds coverage:ignore-file directive on top of the file.', () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/core/injection.config.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(content);

        final injectionConfigFile = InjectionConfigFile();
        injectionConfigFile.addCoverageIgnoreFile();

        final fileContent = injectionConfigFile.file.readAsLinesSync();
        expect(
          fileContent,
          [
            '// coverage:ignore-file',
            '',
            'abc',
            'def',
            'ghi',
          ],
        );
      });
    });

    group('addRouter', () {
      // TODO
    });

    group('replaceGetItAndInjectableImportsWithScalabeCore', () {
      // TODO
    });
  });
}
