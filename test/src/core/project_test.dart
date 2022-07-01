import 'package:scalable_cli/src/core/assets_dir.dart';
import 'package:scalable_cli/src/core/assets_file.dart';
import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:scalable_cli/src/core/injection_test_file.dart';
import 'package:scalable_cli/src/core/main_file.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/presentation_dir.dart';
import 'package:scalable_cli/src/core/project.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:scalable_cli/src/core/router_gr_file.dart';
import 'package:test/test.dart';

void main() {
  group('Project', () {
    group('.isEnabled', () {});

    group('.rootDir', () {
      test('returns instance of RootDir', () {
        final instance = Project.rootDir;
        expect(instance, isA<RootDir>());
      });
    });

    group('.assetsDir', () {
      test('returns instance of AssetsDir', () {
        final instance = Project.assetsDir;
        expect(instance, isA<AssetsDir>());
      });
    });

    group('.presentationDir', () {
      test('returns instance of PresentationDir', () {
        final instance = Project.presentationDir;
        expect(instance, isA<PresentationDir>());
      });
    });

    group('.pubspec', () {
      test('returns instance of PubspecFile', () {
        final instance = Project.pubspec;
        expect(instance, isA<PubspecFile>());
      });
    });

    group('.mainDevelopment', () {
      test('returns instance of MainFile with flavour development', () {
        final instance = Project.mainDevelopment;
        expect(instance, isA<MainFile>());
        expect(instance.flavour, Flavour.development);
      });
    });

    group('.mainTest', () {
      test('returns instance of MainFile with flavour test', () {
        final instance = Project.mainTest;
        expect(instance, isA<MainFile>());
        expect(instance.flavour, Flavour.test);
      });
    });

    group('.mainProduction', () {
      test('returns instance of MainFile with flavour production', () {
        final instance = Project.mainProduction;
        expect(instance, isA<MainFile>());
        expect(instance.flavour, Flavour.production);
      });
    });

    group('.mains', () {
      test(
          'returns set with instance of MainFile with flavour development, '
          'instance of MainFile with flavour test and '
          'instance of MainFile with flavour production', () {
        final set = Project.mains;
        expect(set, isA<Set<MainFile>>());
        expect(set.elementAt(0).flavour, Flavour.development);
        expect(set.elementAt(1).flavour, Flavour.test);
        expect(set.elementAt(2).flavour, Flavour.production);
        expect(set.length, 3);
      });
    });

    group('.assets', () {
      test('returns instance of AssetsFile', () {
        final instance = Project.assets;
        expect(instance, isA<AssetsFile>());
      });
    });

    group('.injectionConfig', () {
      test('returns instance of InjectionConfigFile', () {
        final instance = Project.injectionConfig;
        expect(instance, isA<InjectionConfigFile>());
      });
    });

    group('.routerGrs', () {
      test(
          'returns set with instance of RouterGrFile with platform android, '
          'instance of RouterGrFile with platform ios, '
          'instance of RouterGrFile with platform web, '
          'instance of RouterGrFile with platform linux, '
          'instance of RouterGrFile with platform macos and '
          'instance of RouterGrFile with platform windows', () {
        final set = Project.routerGrs;
        expect(set, isA<Set<RouterGrFile>>());
        expect(set.elementAt(0).platform, Platform.android);
        expect(set.elementAt(1).platform, Platform.ios);
        expect(set.elementAt(2).platform, Platform.web);
        expect(set.elementAt(3).platform, Platform.linux);
        expect(set.elementAt(4).platform, Platform.macos);
        expect(set.elementAt(5).platform, Platform.windows);
        expect(set.length, 6);
      });
    });

    group('.injectionTest', () {
      test('returns instance of InjectionTestFile', () {
        final instance = Project.injectionTest;
        expect(instance, isA<InjectionTestFile>());
      });
    });
  });
}
