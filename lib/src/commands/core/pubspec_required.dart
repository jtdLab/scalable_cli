import 'package:mason/mason.dart';
import 'package:scalable_cli/src/commands/core/logging.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';

/// Provides [runWhenPubspecExists] method.
mixin PubspecRequired on Logging {
  PubspecFile get pubspec;

  /// Runs [callback] when [pubspec] exists else returns error.
  Future<int> runWhenPubspecExists(Future<int> Function() callback) async {
    if (!pubspec.exists) {
      logger.err(
        '''
 Could not find a pubspec.yaml in ${pubspec.file.path}.
 This command should be run from the root of your Scalable project.''',
      );

      return ExitCode.noInput.code;
    }

    return callback();
  }
}
