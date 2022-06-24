import 'package:args/args.dart';
import 'package:scalable_cli/src/commands/core/testable_arg_results.dart';
import 'package:scalable_cli/src/core/platform.dart';

// TODO doc
typedef PlatformGroupHelpBuilder = String Function(PlatformGroup platformGroup);

// TODO doc
typedef PlatformHelpBuilder = String Function(Platform platform);

// TODO doc
extension PlatformFlags on ArgParser {
  // TODO doc
  void addPlatformFlags({
    required PlatformGroupHelpBuilder platformGroupHelp,
    required PlatformHelpBuilder platformHelp,
  }) {
    for (final platformGroup in PlatformGroup.values) {
      addFlag(
        platformGroup.name,
        help: platformGroupHelp(platformGroup),
        negatable: false,
        defaultsTo: false,
      );
    }

    for (final platform in Platform.values) {
      addFlag(
        platform.name,
        help: platformHelp(platform),
        negatable: false,
        defaultsTo: false,
      );
    }
  }
}

// TODO doc
mixin PlatformGetters on TestableArgResults {
  // TODO doc of getters is not correct

  /// Wheter the project supports Android, iOS, Web, Linux, macOS and Windows.
  //bool get _all => argResults['all'] ?? false;

  /// Wheter the project supports Android and iOS.
  bool get _mobile => argResults['mobile'] ?? false;

  /// Wheter the project supports Linux, macOS and Windows.
  bool get _desktop => argResults['desktop'] ?? false;

  /// Wheter the project supports Android.
  bool get android => (argResults['android'] ?? false) || _mobile;

  /// Wheter the project supports iOS.
  bool get ios => (argResults['ios'] ?? false) || _mobile;

  /// Wheter the project supports Web.
  bool get web => (argResults['web'] ?? false);

  /// Wheter the project supports Linux.
  bool get linux => (argResults['linux']) ?? false || _desktop;

  /// Wheter the project supports macOS.
  bool get macos => (argResults['macos']) ?? false || _desktop;

  /// Wheter the project supports Windows.
  bool get windows => (argResults['windows']) ?? false || _desktop;
}
