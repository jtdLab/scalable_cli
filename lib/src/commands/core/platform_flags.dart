import 'package:args/args.dart';
import 'package:scalable_cli/src/commands/core/overridable_arg_results.dart';
import 'package:scalable_cli/src/core/platform.dart';

// TODO doc
const _defaultPlatformGroup = false;

// TODO doc
const _defaultPlatform = false;

/// Signature for method that returns a help string depending on [platformGroup].
typedef PlatformGroupHelpBuilder = String Function(PlatformGroup platformGroup);

/// Signature for method that returns a help string depending on [platform].
typedef PlatformHelpBuilder = String Function(Platform platform);

/// Adds flags for each platform group and platform.
extension PlatformFlags on ArgParser {
  /// Adds `--mobile`, `--desktop`, `--android`, `--ios`, `--web`,
  ///
  /// `--linux`, `--macos` and `--windows` flags.
  void addPlatformFlags({
    required PlatformGroupHelpBuilder platformGroupHelp,
    required PlatformHelpBuilder platformHelp,
  }) {
    for (final platformGroup in PlatformGroup.values) {
      addFlag(
        platformGroup.name,
        help: platformGroupHelp(platformGroup),
        negatable: false,
        defaultsTo: _defaultPlatformGroup,
      );
    }

    for (final platform in Platform.values) {
      addFlag(
        platform.name,
        help: platformHelp(platform),
        negatable: false,
        defaultsTo: _defaultPlatform,
      );
    }
  }
}

/// Adds getters for each platform group and platform.
mixin PlatformGetters on OverridableArgResults {
  /// Whether the user specified that the project supports Android and iOS.
  bool get _mobile => argResults['mobile'] ?? _defaultPlatformGroup;

  /// Whether the user specified that the project supports Linux, macOS and Windows.
  bool get _desktop => argResults['desktop'] ?? _defaultPlatformGroup;

  /// Whether the user specified that the project supports Android.
  bool get android => (argResults['android'] ?? _defaultPlatform) || _mobile;

  /// Whether the user specified that the project supports iOS.
  bool get ios => (argResults['ios'] ?? _defaultPlatform) || _mobile;

  /// Whether the user specified that the project supports Web.
  bool get web => (argResults['web'] ?? _defaultPlatform);

  /// Whether the user specified that the project supports Linux.
  bool get linux => (argResults['linux'] ?? _defaultPlatform) || _desktop;

  /// Whether the user specified that the project supports macOS.
  bool get macos => (argResults['macos'] ?? _defaultPlatform) || _desktop;

  /// Whether the user specified that the project supports Windows.
  bool get windows => (argResults['windows'] ?? _defaultPlatform) || _desktop;
}
