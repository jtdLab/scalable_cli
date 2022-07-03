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
import 'package:universal_io/io.dart';

void main() {
  group('Project', () {
    final cwd = Directory.current;

    setUp(() {
      Directory.current = cwd;
    });

    group('.isEnabled', () {
      group('android', () {
        test(
            'returns true when root directory and presentation directory contain android folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('android').createSync(recursive: true);
          Directory('lib/presentation/android').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.android);
          expect(isEnabled, true);
        });

        test('returns false when root directory contains no android folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('lib/presentation/android').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.android);
          expect(isEnabled, false);
        });

        test(
            'returns false when presentation directory contains no android folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('android').createSync(recursive: true);
          // TODO this might be removed when a potential bug in project file/ dir is fixed
          Directory('lib/presentation').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.android);
          expect(isEnabled, false);
        });
      });

      group('ios', () {
        test(
            'returns true when root directory and presentation directory contain ios folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('ios').createSync(recursive: true);
          Directory('lib/presentation/ios').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.ios);
          expect(isEnabled, true);
        });

        test('returns false when root directory contains no ios folder', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('lib/presentation/ios').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.ios);
          expect(isEnabled, false);
        });

        test('returns false when presentation directory contains no ios folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('ios').createSync(recursive: true);
          // TODO this might be removed when a potential bug in project file/ dir is fixed
          Directory('lib/presentation').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.ios);
          expect(isEnabled, false);
        });
      });

      group('web', () {
        test(
            'returns true when root directory and presentation directory contain web folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('web').createSync(recursive: true);
          Directory('lib/presentation/web').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.web);
          expect(isEnabled, true);
        });

        test('returns false when root directory contains no web folder', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('lib/presentation/web').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.web);
          expect(isEnabled, false);
        });

        test('returns false when presentation directory contains no web folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('web').createSync(recursive: true);
          // TODO this might be removed when a potential bug in project file/ dir is fixed
          Directory('lib/presentation').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.web);
          expect(isEnabled, false);
        });
      });

      group('linux', () {
        test(
            'returns true when root directory and presentation directory contain linux folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('linux').createSync(recursive: true);
          Directory('lib/presentation/linux').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.linux);
          expect(isEnabled, true);
        });

        test('returns false when root directory contains no linux folder', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('lib/presentation/linux').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.linux);
          expect(isEnabled, false);
        });

        test(
            'returns false when presentation directory contains no linux folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('linux').createSync(recursive: true);
          // TODO this might be removed when a potential bug in project file/ dir is fixed
          Directory('lib/presentation').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.linux);
          expect(isEnabled, false);
        });
      });

      group('macos', () {
        test(
            'returns true when root directory and presentation directory contain macos folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('macos').createSync(recursive: true);
          Directory('lib/presentation/macos').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.macos);
          expect(isEnabled, true);
        });

        test('returns false when root directory contains no macos folder', () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('lib/presentation/macos').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.macos);
          expect(isEnabled, false);
        });

        test(
            'returns false when presentation directory contains no macos folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('macos').createSync(recursive: true);
          // TODO this might be removed when a potential bug in project file/ dir is fixed
          Directory('lib/presentation').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.macos);
          expect(isEnabled, false);
        });
      });

      group('windows', () {
        test(
            'returns true when root directory and presentation directory contain windows folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('windows').createSync(recursive: true);
          Directory('lib/presentation/windows').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.windows);
          expect(isEnabled, true);
        });

        test('returns false when root directory contains no windows folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('lib/presentation/windows').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.windows);
          expect(isEnabled, false);
        });

        test(
            'returns false when presentation directory contains no windows folder',
            () {
          final tempDir = Directory.systemTemp.createTempSync();
          Directory.current = tempDir.path;
          Directory('windows').createSync(recursive: true);
          // TODO this might be removed when a potential bug in project file/ dir is fixed
          Directory('lib/presentation').createSync(recursive: true);

          final isEnabled = Project.isEnabled(Platform.windows);
          expect(isEnabled, false);
        });
      });
    });

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
