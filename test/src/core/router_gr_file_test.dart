import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/router_gr_file.dart';
import 'package:test/test.dart';

void main() {
  group('RouterGrFile', () {
    group('path', () {
      test(
          'is "lib/presentation/android/core/router.gr.dart" when platform is android',
          () {
        final file = RouterGrFile(Platform.android);
        final path = file.path;
        expect(path, 'lib/presentation/android/core/router.gr.dart');
      });

      test('is "lib/presentation/ios/core/router.gr.dart" when platform is ios',
          () {
        final file = RouterGrFile(Platform.ios);
        final path = file.path;
        expect(path, 'lib/presentation/ios/core/router.gr.dart');
      });

      test('is "lib/presentation/web/core/router.gr.dart" when platform is web',
          () {
        final file = RouterGrFile(Platform.web);
        final path = file.path;
        expect(path, 'lib/presentation/web/core/router.gr.dart');
      });

      test(
          'is "lib/presentation/linux/core/router.gr.dart" when platform is linux',
          () {
        final file = RouterGrFile(Platform.linux);
        final path = file.path;
        expect(path, 'lib/presentation/linux/core/router.gr.dart');
      });

      test(
          'is "lib/presentation/macos/core/router.gr.dart" when platform is macos',
          () {
        final file = RouterGrFile(Platform.macos);
        final path = file.path;
        expect(path, 'lib/presentation/macos/core/router.gr.dart');
      });

      test(
          'is "lib/presentation/windows/core/router.gr.dart" when platform is windows',
          () {
        final file = RouterGrFile(Platform.windows);
        final path = file.path;
        expect(path, 'lib/presentation/windows/core/router.gr.dart');
      });
    });

    group('file', () {
      // TODO
    });

    group('addCoverageIgnoreFile', () {
      // TODO
    });
  });
}
