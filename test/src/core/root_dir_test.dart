import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:test/test.dart';

void main() {
  group('RootDir', () {
    group('path', () {
      test('is ""', () {
        final file = RootDir();
        final path = file.path;
        expect(path, '');
      });
    });

    group('directory', () {
      // TODO
    });

    group('containsPlatformDir', () {
      // TODO
    });
  });
}
