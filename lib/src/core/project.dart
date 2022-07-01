import 'package:scalable_cli/src/core/assets_dir.dart';
import 'package:scalable_cli/src/core/assets_file.dart';
import 'package:scalable_cli/src/core/injection_test_file.dart';
import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:scalable_cli/src/core/main_file.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/presentation_dir.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:scalable_cli/src/core/router_gr_file.dart';

/// Abstraction of a Scalable project.
class Project {
  /// Wheter [platform] is enabled.
  static bool isEnabled(Platform platform) =>
      rootDir.containsPlatformDir(platform) &&
      presentationDir.containsPlatformDir(platform);

  /// `.`
  static final RootDir rootDir = RootDir();

  /// `assets`
  static final AssetsDir assetsDir = AssetsDir();

  /// `lib/presentation`
  static final PresentationDir presentationDir = PresentationDir();

  /// `pubspec.yaml`
  static final PubspecFile pubspec = PubspecFile();

  /// `lib/main_development.dart`
  static final MainFile mainDevelopment = MainFile(Flavour.development);

  /// `lib/main_test.dart`
  static final MainFile mainTest = MainFile(Flavour.test);

  /// `lib/main_production.dart`
  static final MainFile mainProduction = MainFile(Flavour.production);

  /// `lib/main_development.dart`, `lib/main_test.dart` and `lib/main_production.dart`
  static final Set<MainFile> mains = {
    mainDevelopment,
    mainTest,
    mainProduction
  };

  /// `lib/core/assets.dart`
  static final AssetsFile assets = AssetsFile();

  /// `lib/core/injection.config.dart`
  static final InjectionConfigFile injectionConfig = InjectionConfigFile();

  /// `lib/presentation/android/core/router.dart`, `lib/presentation/ios/core/router.dart`, `lib/presentation/web/core/router.dart`
  /// `lib/presentation/linux/core/router.dart`, `lib/presentation/macos/core/router.dart` and `lib/presentation/windows/core/router.dart`
  static final Set<RouterGrFile> routerGrs = {
    for (final platform in Platform.values) RouterGrFile(platform),
  };

  /// `test/core/injection_test.dart`
  static final InjectionTestFile injectionTest = InjectionTestFile();
}
