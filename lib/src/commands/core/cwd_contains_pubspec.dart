import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:scalable_cli/src/commands/core/logging.dart';
import 'package:universal_io/io.dart';

// TODO name and run + return correct?

/// Provides [cwdContainsPubspec] method.
mixin CwdContainsPubspec on Logging {
  /// Checks wheter [Directory.current] contains pubspec.yaml.
  ///
  /// If no puspec.yaml was found returns error code
  /// else runs + returns [onContainsPubspec].
  Future<int> cwdContainsPubspec({
    required Future<int> Function() onContainsPubspec,
  }) async {
    final targetPath = p.normalize(Directory.current.absolute.path);
    final pubspec = File(p.join(targetPath, 'pubspec.yaml'));

    if (!pubspec.existsSync()) {
      logger.err(
        '''
 Could not find a pubspec.yaml in $targetPath.
 This command should be run from the root of your Scalable project.''',
      );
      return ExitCode.noInput.code;
    }

    return onContainsPubspec();
  }
}
