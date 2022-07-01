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

// TODO static final is wrong should be getter that returns fresh instance each call
// wrong ? already works becuas file or dir getter returns fresh insatnce

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

  // TODO remove
  /*
   static bool _isPubspec(FileSystemEntity entity) {
     final segments = p.split(entity.path).toSet();
     if (segments.intersection(_ignoredDirectories).isNotEmpty) return false;
     if (entity is! File) return false;
     return p.basename(entity.path) == 'pubspec.yaml';
   }
 
   // TODO are this all dirs ?
   static final _ignoredDirectories = {
     ...Platform.values.map((e) => e.name),
     '.symlinks',
     '.plugin_symlinks',
     '.dart_tool',
     'build',
     '.fvm',
   };
 */
}

// TODO remove
/*
 class Project {
   Project();
 
   bool isEnabled(Platform platform) {
     final platformDirInsideRootDirExists = rootDir
         .listSync()
         .any((e) => e is Directory && p.basename(e.path) == platform.name);
     final platformDirInsidePresentationDirExists = presentationDir
         .listSync()
         .any((e) => e is Directory && p.basename(e.path) == platform.name);
 
     return platformDirInsideRootDirExists &&
         platformDirInsidePresentationDirExists;
   }
 
   // TODO impl better 5 iterations up seems hard coded
   Directory get rootDir {
     var cwd = Directory.current;
 
     // Check if cwd is root
     final pubspec = File(p.join(cwd.path, 'pubspec.yaml'));
     if (pubspec.existsSync()) {
       // Cwd is root
       return cwd;
     }
 
     // Check all not ignored subdirs of cwd if they are root
     final entitys = cwd.listSync(recursive: true).where(_isPubspec);
     if (entitys.isNotEmpty) {
       // Subdir is root
       return entitys.first.parent;
     }
 
     // Check parent dirs up to 5 iterations
     for (int i = 0; i < 5; i++) {
       cwd = cwd.parent;
 
       final pubspec = File(p.join(cwd.path, 'pubspec.yaml'));
       if (pubspec.existsSync()) {
         // Cwd is root
         return cwd;
       }
     }
 
     throw PubspecNotFound();
   }
 
   Directory get assetsDir {
     return Directory(p.join(rootDir.path, 'assets'));
   }
 
   Directory get libDir {
     return Directory(p.join(rootDir.path, 'lib'));
   }
 
   Directory get testDir {
     return Directory(p.join(rootDir.path, 'test'));
   }
 
   Directory get coreDir {
     return Directory(p.join(libDir.path, 'core'));
   }
 
   Directory get presentationDir {
     return Directory(p.join(libDir.path, 'presentation'));
   }
 
   Directory get applicationDir {
     return Directory(p.join(libDir.path, 'lib/application'));
   }
 
   Directory get domainDir {
     return Directory(p.join(libDir.path, 'lib/domain'));
   }
 
   Directory get infrastructureDir {
     return Directory(p.join(libDir.path, 'lib/infrastructure'));
   }
 
   PubspecFile get pubspec {
     return PubspecFile(p.join(rootDir.path, 'pubspec.yaml'));
   }
 
   MainFile get mainDevelopment {
     return MainFile(
       p.join(libDir.path, 'main_development.dart'),
       Flavour.development,
     );
   }
 
   MainFile get mainTest {
     return MainFile(
       p.join(libDir.path, 'main_test.dart'),
       Flavour.test,
     );
   }
 
   MainFile get mainProduction {
     return MainFile(
       p.join(libDir.path, 'main_production.dart'),
       Flavour.production,
     );
   }
 
   AssetsFile get assets {
     return AssetsFile(p.join(coreDir.path, 'assets.dart'), assetsDir.path);
   }
 
   File get injection {
     return File(p.join(coreDir.path, 'injection.dart'));
   }
 
   InjectionConfigFile get injectionConfig {
     return InjectionConfigFile(p.join(coreDir.path, 'injection.config.dart'));
   }
 
   File router(String platform) {
     return File(
       p.join(presentationDir.path, '$platform/core/router.dart'),
     );
   }
 
   File routerGr(String platform) {
     return File(
       p.join(presentationDir.path, '$platform/core/router.gr.dart'),
     );
   }
 
   InjectableTestFile get injectableTest {
     return InjectableTestFile(
       p.join(testDir.path, 'core/injectable_test.dart'),
     );
   }
 
   bool _isPubspec(FileSystemEntity entity) {
     final segments = p.split(entity.path).toSet();
     if (segments.intersection(_ignoredDirectories).isNotEmpty) return false;
     if (entity is! File) return false;
     return p.basename(entity.path) == 'pubspec.yaml';
   }
 
   // TODO are this all dirs ?
   final _ignoredDirectories = {
     ...Platform.values.map((e) => e.name),
     '.symlinks',
     '.plugin_symlinks',
     '.dart_tool',
     'build',
     '.fvm',
   };
 }
 */
