import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

/// Adds logging.
mixin Logging on Command<int> {
  /// Gets the logger.
  Logger get logger;
}
