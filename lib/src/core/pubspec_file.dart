import 'package:path/path.dart' as p;
import 'package:plain_optional/plain_optional.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:scalable_cli/src/core/assets_dir.dart';
import 'package:scalable_cli/src/core/project.dart';
import 'package:scalable_cli/src/core/project_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:universal_io/io.dart';

class PubspecNameNotFound implements Exception {
  @override
  String toString() => 'Pubspec.yaml doest not contain name property.';
}

class PubspecDescriptionNotFound implements Exception {
  @override
  String toString() => 'Pubspec.yaml does not contain description property.';
}

class RegularFileMissing implements Exception {
  @override
  String toString() =>
      'You did not provide a <YourFont>-Regular.ttf for your font.';
}

/// {@template pubspec_file}
/// Abstraction of the `pubspec.yaml` file in a Scalable project.
/// {@endtemplate}
class PubspecFile extends ProjectFile {
  /// {@macro pubspec_file}
  PubspecFile({RootDir? rootDir, AssetsDir? assetsDir})
      : _rootDir = rootDir ?? Project.rootDir,
        _assetsDir = assetsDir ?? Project.assetsDir,
        super('pubspec.yaml');

  final RootDir _rootDir;
  final AssetsDir _assetsDir;

  /// Gets the name of this.
  String get name {
    try {
      final pubspecYaml = file.readAsStringSync().toPubspecYaml();
      return pubspecYaml.name;
    } catch (_) {
      throw PubspecNameNotFound();
    }
  }

  /// Gets the description of this.
  String? get description {
    try {
      final pubspecYaml = file.readAsStringSync().toPubspecYaml();
      return pubspecYaml.description.unsafe;
    } catch (_) {
      throw PubspecDescriptionNotFound();
    }
  }

  /// Wheter this exists.
  bool get exists => file.existsSync();

  // TODO better name
  void updateFlutterAssets() {
    final rootDir = _rootDir.directory;
    final assetsDir = _assetsDir.directory;

    final assetsFromFileSystem = <String>[];
    final assetFiles = assetsDir.listSync().whereType<File>();
    if (assetFiles.isNotEmpty) {
      assetsFromFileSystem.add('assets/');
    }

    final assetsFromPubspec = _readAssets();
    assetsFromFileSystem.addAll(
      assetsDir
          .listSync(recursive: true)
          .whereType<Directory>()
          .where((e) {
            final sub = e.listSync().whereType<File>();
            if (sub.isEmpty ||
                (sub.length == 1 &&
                    p.basenameWithoutExtension(sub.first.path) == 'README')) {
              return false;
            }

            return true;
          })
          .map((e) => '${p.relative(e.path, from: rootDir.path)}/')
          .toList(),
    );

    final updatedAssets = (assetsFromFileSystem
      ..addAll(
        assetsFromPubspec..removeWhere((e) => e.startsWith('assets')),
      ));

    _writeAssets(updatedAssets);
  }

  // TODO better name
  void updateFlutterFonts() {
    final rootDir = _rootDir.directory;

    final fontDirs = Directory(p.join(rootDir.path, 'assets', 'fonts'))
        .listSync()
        .whereType<Directory>();

    final fontFamilies = <_FontFamily>[];
    for (final fontDir in fontDirs) {
      // 1. Get FAMILY from rootDir/assets/fonts/<FAMILY in snake-case>
      final File regularFile;
      try {
        regularFile = fontDir
            .listSync()
            .whereType<File>()
            .firstWhere((e) => e.path.endsWith('-Regular.ttf'));
      } catch (_) {
        throw RegularFileMissing();
      }
      // TODO maybe throw error if not correct file nameing
      final familyName = p.basename(regularFile.path).split('-').first;

      // 2. Get all .ttfs in rootDir/assets/fonts/<FAMILY in snake-case> and call them FONT
      final fontFiles = fontDir
          .listSync()
          .whereType<File>()
          .where((file) => p.extension(file.path) == '.ttf');

      final fonts = <_Font>[];
      for (final fontFile in fontFiles) {
        // 3. For each FONT extract style, weight and add them to fonts: directive
        final path = p.relative(fontFile.path, from: rootDir.path);

        final styleAndWeight = p.basename(fontFile.path).split('-').last;

        final style = styleAndWeight.contains('Italic') ? 'italic' : null;

        final weight = styleAndWeight.contains('Black')
            ? 900
            : styleAndWeight.contains('ExtraBold')
                ? 800
                : styleAndWeight.contains('SemiBold')
                    ? 600
                    : styleAndWeight.contains('Bold')
                        ? 700
                        : styleAndWeight.contains('Medium')
                            ? 500
                            : styleAndWeight.contains('ExtraLight')
                                ? 200
                                : styleAndWeight.contains('Light')
                                    ? 300
                                    : styleAndWeight.contains('Thin')
                                        ? 100
                                        : 400;
        fonts.add(_Font(path, style, weight));
      }
      fontFamilies.add(_FontFamily(familyName, fonts));
    }

    _writeFonts(fontFamilies);
  }

  void addDependency(String name, String version) {
    // Read from disc
    final pubspecYaml = file.readAsStringSync().toPubspecYaml();

    final updatedDependencies = pubspecYaml.dependencies.toList();
    updatedDependencies.add(
      PackageDependencySpec.hosted(
        HostedPackageDependencySpec(
          package: name,
          version: Optional(version),
        ),
      ),
    );

    final updatedPubspecYaml = pubspecYaml.copyWith(
      dependencies: updatedDependencies,
    );

    // Write to disc
    file.writeAsStringSync(
      updatedPubspecYaml.toYamlString().replaceAll('\'', '"'),
    );
  }

  List<String> _readAssets() {
    // Read from disc
    final pubspecYaml = file.readAsStringSync().toPubspecYaml();

    final dynamic parsed;
    try {
      parsed = pubspecYaml.customFields['flutter']['assets'];
      return List.castFrom<dynamic, String>(parsed).toList();
    } catch (_) {
      return [];
    }
  }

  void _writeAssets(List<String> assets) {
    // Read from disc
    final pubspecYaml = file.readAsStringSync().toPubspecYaml();

    // Update assets section
    Map<String, dynamic> newFlutter = {};
    final flutter = pubspecYaml.customFields.containsKey('flutter');
    if (flutter) {
      newFlutter = pubspecYaml.customFields['flutter'];
    }

    newFlutter.addAll({
      'assets': assets,
    });

    final updatedPubspecYaml = pubspecYaml.copyWith(
      customFields: pubspecYaml.customFields
        ..addAll(
          {
            'flutter': newFlutter,
          },
        ),
    );

    // Write to disc
    file.writeAsStringSync(
      updatedPubspecYaml.toYamlString().replaceAll('\'', '"'),
    );
  }

  List<String> _readFonts() {
    // TODO: implement
    throw UnimplementedError();
  }

  void _writeFonts(List<_FontFamily> fontFamilies) {
    // Read from disc
    final pubspecYaml = file.readAsStringSync().toPubspecYaml();

    // Update assets section
    Map<String, dynamic> newFlutter = {};
    final flutter = pubspecYaml.customFields.containsKey('flutter');
    if (flutter) {
      newFlutter = pubspecYaml.customFields['flutter'];
    }

    newFlutter.addAll({
      'fonts': fontFamilies.map((e) => e.toMap()).toList(),
    });

    final updatedPubspecYaml = pubspecYaml.copyWith(
      customFields: pubspecYaml.customFields
        ..addAll(
          {
            'flutter': newFlutter,
          },
        ),
    );

    // Write to disc
    file.writeAsStringSync(
      updatedPubspecYaml.toYamlString().replaceAll('\'', '"'),
    );
  }
}

// TODO cleaner
class _FontFamily {
  final String name;
  final List<_Font> fonts;

  _FontFamily(this.name, this.fonts);

  Map<String, dynamic> toMap() {
    fonts.sort(
      (a, b) {
        if (a.style == null && b.style != null) {
          return -1;
        }

        if (a.style != null && b.style == null) {
          return 1;
        }

        return a.weight.compareTo(b.weight);
      },
    );

    return {
      'family': name,
      'fonts': fonts.map((e) => e.toMap()).toList(),
    };
  }
}

// TODO cleaner
class _Font {
  final String path;
  final String? style;
  final int weight;

  _Font(this.path, this.style, this.weight);

  Map<String, dynamic> toMap() {
    return {
      'asset': path,
      if (style != null) 'style': style!,
      'weight': weight,
    };
  }
}
