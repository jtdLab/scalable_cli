import 'package:scalable_cli/src/core/platform.dart';
import 'package:test/test.dart';

void main() {
  group('PlatformGroup', () {
    group('platforms', () {
      test('given PlatformGroup.mobile return [Platform.android, Platform.ios]',
          () {
        const group = PlatformGroup.mobile;
        expect(group.platforms, [Platform.android, Platform.ios]);
      });

      test(
          'given PlatformGroup.mobile return [Platform.linux, Platform.macos, Platform.windows]',
          () {
        const group = PlatformGroup.desktop;
        expect(
          group.platforms,
          [Platform.linux, Platform.macos, Platform.windows],
        );
      });
    });
  });

  group('Platform', () {
    group('prettyName', () {
      test('given Platform.android return "Android"', () {
        const platform = Platform.android;
        expect(platform.prettyName, 'Android');
      });

      test('given Platform.android return "iOS"', () {
        const platform = Platform.ios;
        expect(platform.prettyName, 'iOS');
      });

      test('given Platform.android return "Web"', () {
        const platform = Platform.web;
        expect(platform.prettyName, 'Web');
      });

      test('given Platform.android return "Linux"', () {
        const platform = Platform.linux;
        expect(platform.prettyName, 'Linux');
      });

      test('given Platform.android return "macOS"', () {
        const platform = Platform.macos;
        expect(platform.prettyName, 'macOS');
      });

      test('given Platform.android return "Windows"', () {
        const platform = Platform.windows;
        expect(platform.prettyName, 'Windows');
      });
    });
  });

  group('PlatformListX', () {
    group('prettyEnumeration', () {
      test('given empty list return null', () {
        final list = <Platform>[];
        expect(list.prettyEnumeration, null);
      });

      test('given [Platform.android] return "Android"', () {
        final list = [Platform.android];
        expect(list.prettyEnumeration, 'Android');
      });

      test('given [Platform.ios] return "iOS"', () {
        final list = [Platform.ios];
        expect(list.prettyEnumeration, 'iOS');
      });

      test('given [Platform.web] return "Web"', () {
        final list = [Platform.web];
        expect(list.prettyEnumeration, 'Web');
      });

      test('given [Platform.linux] return "Linux"', () {
        final list = [Platform.linux];
        expect(list.prettyEnumeration, 'Linux');
      });

      test('given [Platform.macos] return "macOS"', () {
        final list = [Platform.macos];
        expect(list.prettyEnumeration, 'macOS');
      });

      test('given [Platform.windows] return "Windows"', () {
        final list = [Platform.windows];
        expect(list.prettyEnumeration, 'Windows');
      });

      test(
          'given [Platform.ios, Platform.web, Platform.linux] return "iOS, Web and Linux"',
          () {
        final list = [Platform.ios, Platform.web, Platform.linux];
        expect(list.prettyEnumeration, 'iOS, Web and Linux');
      });
    });
  });
}
