import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

void main() {
  group('RootDir', () {
    final cwd = Directory.current;

    setUp(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is ""', () {
        final rootDir = RootDir();
        expect(rootDir.path, '');
      });
    });

    group('directory', () {
      test('has path ""', () {
        final rootDir = RootDir();
        expect(rootDir.path, '');
      });
    });

    group('containsPlatformDir', () {
      group('given platform is android', () {
        test('returns true when android sub directory exists', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          final dir = Directory('android');
          dir.createSync(recursive: true);

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.android), true);
        });

        test('returns false when android sub directory does not exist', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.android), false);
        });
      });

      group('given platform is ios', () {
        test('returns true when ios sub directory exists', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          final dir = Directory('ios');
          dir.createSync(recursive: true);

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.ios), true);
        });

        test('returns false when ios sub directory does not exist', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.ios), false);
        });
      });

      group('given platform is web', () {
        test('returns true when web sub directory exists', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          final dir = Directory('web');
          dir.createSync(recursive: true);

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.web), true);
        });

        test('returns false when web sub directory does not exist', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.web), false);
        });
      });

      group('given platform is linux', () {
        test('returns true when linux sub directory exists', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          final dir = Directory('linux');
          dir.createSync(recursive: true);

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.linux), true);
        });

        test('returns false when linux sub directory does not exist', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.linux), false);
        });
      });

      group('given platform is macos', () {
        test('returns true when macos sub directory exists', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          final dir = Directory('macos');
          dir.createSync(recursive: true);

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.macos), true);
        });

        test('returns false when macos sub directory does not exist', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.macos), false);
        });
      });

      group('given platform is windows', () {
        test('returns true when windows sub directory exists', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          final dir = Directory('windows');
          dir.createSync(recursive: true);

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.windows), true);
        });

        test('returns false when windows sub directory does not exist', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;

          final rootDir = RootDir();
          expect(rootDir.containsPlatformDir(Platform.windows), false);
        });
      });
    });
  });
}
