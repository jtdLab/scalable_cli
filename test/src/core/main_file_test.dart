import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/core/main_file.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const invalidMainFile = '''
void main() {
  runApp(MyApp());
}
''';

const singlePlatformMainFile = '''
import 'package:example/bootstrap.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/android/app.dart' as android;
import 'package:scalable/presentation.dart';

void main() {
  bootstrap(() {
    configureLogging(Level.INFO);

    return PlatformWidget(
      android: (context) {
        configureDependencies(Environment.dev, Platform.android);
        return const android.App();
      },
    );
  });
}
''';

const multiPlatformMainFile = '''
import 'package:example/bootstrap.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/android/app.dart' as android;
import 'package:example/presentation/windows/app.dart' as windows;
import 'package:scalable/presentation.dart';

void main() {
  bootstrap(() {
    configureLogging(Level.INFO);

    return PlatformWidget(
      android: (context) {
        configureDependencies(Environment.dev, Platform.android);
        return const android.App();
      },
      windows: (context) {
        configureDependencies(Environment.dev, Platform.windows);
        return const windows.App();
      },
    );
  });
}
''';

class MockPubspecFile extends Mock implements PubspecFile {}

void main() {
  group('Flavour', () {
    group('toAnnotationString', () {
      test('given Flavour.development return "dev"', () {
        const flavour = Flavour.development;
        expect(flavour.toAnnotationString(), 'dev');
      });

      test('given Flavour.test return "test"', () {
        const flavour = Flavour.test;
        expect(flavour.toAnnotationString(), 'test');
      });

      test('given Flavour.production return "prod"', () {
        const flavour = Flavour.production;
        expect(flavour.toAnnotationString(), 'prod');
      });
    });
  });

  group('MainFile', () {
    late PubspecFile pubspec;

    setUp(() {
      pubspec = MockPubspecFile();
      when(() => pubspec.name).thenReturn('example');
    });

    group('addPlatform', () {
      test(
          'throws InvalidMainFile when the underlying file contains unexpected content',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/main_development.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(invalidMainFile);

        final mainFile = MainFile(Flavour.development, pubspec: pubspec);
        expect(
          () => mainFile.addPlatform(Platform.android),
          throwsA(isA<InvalidMainFile>()),
        );
      });

      test(
          'does not change the undelying file content if the given platform was already enabled',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/main_development.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(singlePlatformMainFile);

        final mainFile = MainFile(Flavour.development, pubspec: pubspec);
        mainFile.addPlatform(Platform.android);

        final fileContent = mainFile.file.readAsStringSync();
        expect(fileContent, singlePlatformMainFile);
      });

      test(
          'updates the underlying file content correctly (single platform already enabled)',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/main_development.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(singlePlatformMainFile);

        final mainFile = MainFile(Flavour.development, pubspec: pubspec);
        mainFile.addPlatform(Platform.ios);

        final fileContent = mainFile.file.readAsStringSync();
        expect(fileContent, '''
import 'package:example/bootstrap.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/android/app.dart' as android;
import 'package:example/presentation/ios/app.dart' as ios;
import 'package:scalable/presentation.dart';

void main() {
  bootstrap(() {
    configureLogging(Level.INFO);

    return PlatformWidget(
      android: (context) {
        configureDependencies(Environment.dev, Platform.android);
        return const android.App();
      },
      ios: (context) {
        configureDependencies(Environment.dev, Platform.ios);
        return const ios.App();
      },
    );
  });
}
''');
      });

      test(
          'updates the underlying file content correctly (multiple platforms already enabled)',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/main_development.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(multiPlatformMainFile);

        final mainFile = MainFile(Flavour.development, pubspec: pubspec);
        mainFile.addPlatform(Platform.ios);

        final fileContent = mainFile.file.readAsStringSync();
        expect(fileContent, '''
import 'package:example/bootstrap.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/android/app.dart' as android;
import 'package:example/presentation/ios/app.dart' as ios;
import 'package:example/presentation/windows/app.dart' as windows;
import 'package:scalable/presentation.dart';

void main() {
  bootstrap(() {
    configureLogging(Level.INFO);

    return PlatformWidget(
      android: (context) {
        configureDependencies(Environment.dev, Platform.android);
        return const android.App();
      },
      windows: (context) {
        configureDependencies(Environment.dev, Platform.windows);
        return const windows.App();
      },
      ios: (context) {
        configureDependencies(Environment.dev, Platform.ios);
        return const ios.App();
      },
    );
  });
}
''');
      });
    });
  });
}
