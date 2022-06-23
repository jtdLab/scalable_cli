import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

// TODO doc
mixin TestableArgResults on Command<int> {
  /// [ArgResults] which can be overridden for testing.
  @visibleForTesting
  ArgResults? argResultOverrides;

  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;
}
