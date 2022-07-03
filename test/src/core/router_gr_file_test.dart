import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/router_gr_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

void main() {
  group('RouterGrFile', () {
    final cwd = Directory.current;

    setUp(() {
      Directory.current = cwd;
    });

    group('path', () {
      test(
          'is "lib/presentation/android/core/router.gr.dart" when platform is android',
          () {
        final routerGrFile = RouterGrFile(Platform.android);
        expect(
          routerGrFile.path,
          'lib/presentation/android/core/router.gr.dart',
        );
      });

      test('is "lib/presentation/ios/core/router.gr.dart" when platform is ios',
          () {
        final routerGrFile = RouterGrFile(Platform.ios);
        expect(routerGrFile.path, 'lib/presentation/ios/core/router.gr.dart');
      });

      test('is "lib/presentation/web/core/router.gr.dart" when platform is web',
          () {
        final routerGrFile = RouterGrFile(Platform.web);
        expect(routerGrFile.path, 'lib/presentation/web/core/router.gr.dart');
      });

      test(
          'is "lib/presentation/linux/core/router.gr.dart" when platform is linux',
          () {
        final routerGrFile = RouterGrFile(Platform.linux);
        expect(routerGrFile.path, 'lib/presentation/linux/core/router.gr.dart');
      });

      test(
          'is "lib/presentation/macos/core/router.gr.dart" when platform is macos',
          () {
        final routerGrFile = RouterGrFile(Platform.macos);
        expect(routerGrFile.path, 'lib/presentation/macos/core/router.gr.dart');
      });

      test(
          'is "lib/presentation/windows/core/router.gr.dart" when platform is windows',
          () {
        final routerGrFile = RouterGrFile(Platform.windows);
        expect(
          routerGrFile.path,
          'lib/presentation/windows/core/router.gr.dart',
        );
      });
    });

    group('file', () {
      test(
          'has path "lib/presentation/android/core/router.gr.dart" when platform is android',
          () {
        final routerGrFile = RouterGrFile(Platform.android);
        expect(
          routerGrFile.file.path,
          'lib/presentation/android/core/router.gr.dart',
        );
      });

      test(
          'has path "lib/presentation/ios/core/router.gr.dart" when platform is ios',
          () {
        final routerGrFile = RouterGrFile(Platform.ios);
        expect(
          routerGrFile.file.path,
          'lib/presentation/ios/core/router.gr.dart',
        );
      });

      test(
          'has path "lib/presentation/web/core/router.gr.dart" when platform is web',
          () {
        final routerGrFile = RouterGrFile(Platform.web);
        expect(
          routerGrFile.file.path,
          'lib/presentation/web/core/router.gr.dart',
        );
      });

      test(
          'has path "lib/presentation/linux/core/router.gr.dart" when platform is linux',
          () {
        final routerGrFile = RouterGrFile(Platform.linux);
        expect(
          routerGrFile.file.path,
          'lib/presentation/linux/core/router.gr.dart',
        );
      });

      test(
          'has path "lib/presentation/macos/core/router.gr.dart" when platform is macos',
          () {
        final routerGrFile = RouterGrFile(Platform.macos);
        expect(
          routerGrFile.file.path,
          'lib/presentation/macos/core/router.gr.dart',
        );
      });

      test(
          'has path "lib/presentation/windows/core/router.gr.dart" when platform is windows',
          () {
        final routerGrFile = RouterGrFile(Platform.windows);
        expect(
          routerGrFile.file.path,
          'lib/presentation/windows/core/router.gr.dart',
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
        final file = File('lib/presentation/android/core/router.gr.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(content);

        final routerGrFile = RouterGrFile(Platform.android);
        routerGrFile.addCoverageIgnoreFile();

        final fileContent = routerGrFile.file.readAsLinesSync();
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
  });
}
