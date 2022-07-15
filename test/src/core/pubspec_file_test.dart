import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const pubspecWithName = '''
name: example
environment:
  sdk: ">=2.13.0 <3.0.0"

dev_dependencies:
  test: any''';

const pubspecWithOutName = '''
environment:
  sdk: ">=2.13.0 <3.0.0"

dev_dependencies:
  test: any''';

const pubspecWithDescription = '''
name: example
description: Some description.
environment:
  sdk: ">=2.13.0 <3.0.0"

dev_dependencies:
  test: any''';

void main() {
  group('InjectionConfigFile', () {
    final cwd = Directory.current;

    setUp(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is "pubspec.yaml"', () {
        final pubspecFile = PubspecFile();
        expect(
          pubspecFile.path,
          'pubspec.yaml',
        );
      });
    });

    group('file', () {
      test('has path "pubspec.yaml"', () {
        final pubspecFile = PubspecFile();
        expect(
          pubspecFile.file.path,
          'pubspec.yaml',
        );
      });
    });

    group('name', () {
      // TODO cleaner

      test('returns the correct value', () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('pubspec.yaml');
        file.createSync(recursive: true);
        file.writeAsStringSync(pubspecWithName);

        final pubspecFile = PubspecFile();

        final name = pubspecFile.name;
        expect(name, 'example');
      });

      test('throws PubspecNameNotFound when no name found', () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('pubspec.yaml');
        file.createSync(recursive: true);
        file.writeAsStringSync(pubspecWithOutName);

        final pubspecFile = PubspecFile();

        expect(() => pubspecFile.name, throwsA(isA<PubspecNameNotFound>()));
      });
    });

    group('description', () {
      // TODO cleaner

      test('returns the correct value', () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('pubspec.yaml');
        file.createSync(recursive: true);
        file.writeAsStringSync(pubspecWithDescription);

        final pubspecFile = PubspecFile();

        final description = pubspecFile.description;
        expect(description, 'Some description.');
      });
    });

    group('exists', () {
      test('returns true when the file exists', () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('pubspec.yaml');
        file.createSync(recursive: true);

        final pubspecFile = PubspecFile();

        final exists = pubspecFile.exists;
        expect(exists, true);
      });

      test('returns false when the file does not exist', () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;

        final pubspecFile = PubspecFile();

        final exists = pubspecFile.exists;
        expect(exists, false);
      });
    });

    group('updateFlutterAssets', () {
      // TODO
    });

    group('updateFlutterFonts', () {
      // TODO
    });

    group('addDependency', () {
      // TODO
    });
  });
}
