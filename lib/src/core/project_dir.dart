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
