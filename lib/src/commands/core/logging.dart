import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

mixin Logging on Command<int> {
  // TODO doc
  Logger get logger;
}
