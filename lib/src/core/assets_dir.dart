import 'package:scalable_cli/src/core/project_dir.dart';
import 'package:universal_io/io.dart';
import 'package:path/path.dart' as p;

/// Provides [listFiles] method.
extension GetFiles on Directory {
  /// Lists the files of this [Directory]. Optionally recurses into sub-directories.
  Iterable<File> listFiles({bool recursive = false}) =>
      listSync(recursive: recursive).whereType<File>();
}

/// Provides [isEmptyOrContainsOnlyReadMe] method.
extension IsEmptyOrContainsOnlyReadMe on Iterable<File> {
  /// Wheter this contains 1+ `README.md` files or no files at all.
  bool isEmptyOrContainsOnlyReadMe() =>
      isEmpty ||
      (length == 1 && p.basenameWithoutExtension(first.path) == 'README');
}

/// {@template assets_dir}
/// Abstraction of the `assets` directory in a Scalable project.
/// {@endtemplate}
class AssetsDir extends ProjectDir {
  /// {@macro assets_dir}
  AssetsDir() : super('assets');

  /// Returns the paths to the assets that need to be added to pubspec.yaml assets section
  /// in order to use in a flutter project.
  ///
  /// https://docs.flutter.dev/development/ui/assets-and-images
  List<String> pubspecPaths() {
    final pubspecPaths = <String>[];
    // Files in assets/
    final assetFiles = directory.listFiles();
    if (!assetFiles.isEmptyOrContainsOnlyReadMe()) {
      pubspecPaths.add('assets/');
    }

    pubspecPaths.addAll(
      directory
          .listSync(recursive: true)
          .whereType<Directory>()
          .where((e) => !e.listFiles().isEmptyOrContainsOnlyReadMe())
          .map((e) => 'assets/${p.relative(e.path, from: directory.path)}/'),
    );

    return pubspecPaths;
  }

  /// Returns list of directories inside this which contain at least one file
  /// that is not a README.md.
  List<Directory> notEmptyDirs() {
    return directory
        .listSync(recursive: true)
        .whereType<Directory>()
        .where((e) => !e.listFiles().isEmptyOrContainsOnlyReadMe())
        .toList();
  }

  /// TODO doc
  List<FileSystemEntity> assets() {
    // TODO implement
    throw UnimplementedError();
  }

  /// TODO doc
  // should parse file tree to a usable objects that will be consumed by pubspec generate assets/fonts methods
  List<dynamic> readAsAssetDirs() {
    // TODO implement
    throw UnimplementedError();
  }
}

/* 
 class RootAssetsClass {
   final String path;
   final List<String> properties;
 }
 
 class PrivateAssetClass {
   final String path;
   final List<String> properties;
 }
 
 class Property {
   final String name;
 } */

///   AssetDir readAsAssetDir() {
///     final assetFiles = directory.listSync().whereType<File>();
///     if (!assetFiles.isEmptyOrContainsOnlyReadMe()) {
///       return AssetDir(isRoot: true);
///     }
///
///     final assets = <AssetFile>[];
///     // TODO
///
///     final subDirs = <AssetDir>[];
///     // TODO
///
///     return AssetDir(isRoot: true, assets: assets, subDirs: subDirs);
///   }
///
/// /// Abstraction of a directory inside `assets` directory in a Scalable  project.
/// class AssetDir {
///   final bool isRoot;
///   final List<AssetFile> assets;
///   final List<AssetDir> subDirs;
///
///   AssetDir({
///     this.isRoot = false,
///     this.assets = const [],
///     this.subDirs = const [],
///   });
/// }
///
/// /// Abstraction of a file inside `assets` directory in a Scalable  project.
/// class AssetFile {
///   final String path;
///
///   AssetFile({required this.path});
///
///   String get name => p.basenameWithoutExtension(path);
/// }
///
///
///
/// class AssetClass {
///   final String name;
///   final String path;
///   final List<Property> properties;
/// }
///
/// class Property {
///   String name;
///   String value;
///
///   Property(this.name, this.value);
/// }
///

