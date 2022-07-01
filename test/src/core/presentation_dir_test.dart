import 'package:scalable_cli/src/core/presentation_dir.dart';
import 'package:test/test.dart';

void main() {
  group('PresentationDir', () {
    group('path', () {
      test('is ""', () {
        final file = PresentationDir();
        final path = file.path;
        expect(path, 'lib/presentation');
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
