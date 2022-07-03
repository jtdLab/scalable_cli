import 'package:path/path.dart' as p;
import 'package:scalable_cli/src/core/platform.dart';
import 'package:universal_io/io.dart';

/// Provides [containsPlatformDir] method.
mixin ContainsPlatformDir on ProjectDir {
  // TODO return false if this dir does not exist this will trigger some changes in test impls that use project files
  /// Returns wheter this contains a sub directory that belongs to [platform].
  bool containsPlatformDir(Platform platform) => directory
      .listSync()
      .any((e) => e is Directory && p.basename(e.path) == platform.name);
}

/// {@template project_dir}
/// Base class for a directory in a Scalable project.
/// {@endtemplate}
abstract class ProjectDir {
  /// {@macro project_dir}
  ProjectDir([this.path = '']);

  /// The path of this.
  final String path;

  /// Gets the underlying directory of this.
  Directory get directory => Directory(path);
}
