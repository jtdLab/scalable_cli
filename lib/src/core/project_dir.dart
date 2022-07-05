import 'package:path/path.dart' as p;
import 'package:scalable_cli/src/core/platform.dart';
import 'package:universal_io/io.dart';

/// Provides [containsPlatformDir] method.
mixin ContainsPlatformDir on ProjectDir {
  /// Returns wheter this contains a sub directory that belongs to [platform].
  bool containsPlatformDir(Platform platform) {
    if (directory.existsSync()) {
      return directory
          .listSync()
          .any((e) => e is Directory && p.basename(e.path) == platform.name);
    }

    return false;
  }
}

/// {@template project_dir}
/// Base class for a directory in a Scalable project.
/// {@endtemplate}
abstract class ProjectDir {
  /// {@macro project_dir}
  ProjectDir([this.path = '.']);

  /// The path of this.
  final String path;

  /// Gets the underlying directory of this.
  Directory get directory => Directory(path);
}

/* /// {@template project_dir}
/// Base class for a directory in a Scalable project.
/// {@endtemplate}
abstract class ProjectDir2 implements Directory {
  /// The underlying directory.
  final Directory _directory;

  /// {@macro project_dir}
  ProjectDir2(String path) : _directory = Directory(path);

  @override
  Directory get absolute => _directory.absolute;

  @override
  Future<Directory> create({bool recursive = false}) =>
      _directory.create(recursive: recursive);

  @override
  void createSync({bool recursive = false}) =>
      _directory.createSync(recursive: recursive);
  @override
  Future<Directory> createTemp([String? prefix]) =>
      _directory.createTemp(prefix);

  @override
  Directory createTempSync([String? prefix]) =>
      _directory.createTempSync(prefix);

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) =>
      _directory.delete(recursive: recursive);

  @override
  void deleteSync({bool recursive = false}) =>
      _directory.deleteSync(recursive: recursive);

  @override
  Future<bool> exists() => _directory.exists();

  @override
  bool existsSync() => _directory.existsSync();

  @override
  bool get isAbsolute => _directory.isAbsolute;

  @override
  Stream<FileSystemEntity> list({
    bool recursive = false,
    bool followLinks = true,
  }) =>
      _directory.list(recursive: recursive, followLinks: followLinks);

  @override
  List<FileSystemEntity> listSync({
    bool recursive = false,
    bool followLinks = true,
  }) =>
      _directory.listSync(recursive: recursive, followLinks: followLinks);

  @override
  Directory get parent => _directory.parent;

  @override
  String get path => _directory.path;

  @override
  Future<Directory> rename(String newPath) => _directory.rename(newPath);

  @override
  Directory renameSync(String newPath) => _directory.renameSync(newPath);

  @override
  Future<String> resolveSymbolicLinks() => _directory.resolveSymbolicLinks();

  @override
  String resolveSymbolicLinksSync() => _directory.resolveSymbolicLinksSync();

  @override
  Future<FileStat> stat() => _directory.stat();

  @override
  FileStat statSync() => _directory.statSync();

  @override
  Uri get uri => _directory.uri;

  @override
  Stream<FileSystemEvent> watch({
    int events = FileSystemEvent.all,
    bool recursive = false,
  }) =>
      _directory.watch(events: events, recursive: recursive);
} */
