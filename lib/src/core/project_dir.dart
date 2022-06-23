import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:scalable_cli/src/core/platform.dart';
import 'package:universal_io/io.dart';

/// Provides [containsPlatformDir] method.
mixin ContainsPlatformDir on ProjectDir {
  /// Returns wheter this contains a sub directory that belongs to [platform].
  bool containsPlatformDir(Platform platform) => directory
      .listSync()
      .any((e) => e is Directory && p.basename(e.path) == platform.name);
}

/// {@template project_dir}
/// Base class for a directory in a Scalable project.
/// {@endtemplate}
abstract class ProjectDir {
  /// [Directory] which can be overridden for testing.
  @visibleForTesting
  Directory? cwdOverrides;

  /// Gets the current working directory.
  Directory get cwd => cwdOverrides ?? Directory.current;

  /// {@macro project_dir}
  ProjectDir([this.path = '']);

  /// Gets the path of this.
  final String path;

  /// Gets the directory of this.
  Directory get directory => Directory(p.join(cwd.path, path));
}
