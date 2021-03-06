import 'dart:async';

import 'package:args/command_runner.dart' show UsageException;
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:scalable_cli/src/cli/cli.dart';
import 'package:scalable_cli/src/commands/commands.dart';
import 'package:scalable_cli/src/commands/core/dependency_versions.dart';
import 'package:scalable_cli/src/commands/core/generator_builder.dart';
import 'package:scalable_cli/src/commands/core/org_name_option.dart';
import 'package:scalable_cli/src/commands/core/platform_flags.dart';
import 'package:scalable_cli/src/commands/core/overridable_arg_results.dart';
import 'package:scalable_cli/src/commands/create/scalable_core_bundle.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:universal_io/io.dart';

/// The default description.
const _defaultDescription = 'A Scalable app.';

/// The default value for support of example pages, blocs and services.
const _defaultExample = true;

// A valid Dart identifier that can be used for a package, i.e. no
// capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final _identifierRegExp = RegExp('[a-z_][a-z0-9_]*');

/// {@template create_command}
/// `scalable create` command creates a new Scalable project in the specified directory.
/// {@endtemplate}
class CreateCommand extends ScalableCommand
    with OverridableArgResults, OrgNameGetters, PlatformGetters {
  /// {@macro create_command}
  CreateCommand({
    Logger? logger,
    FlutterInstalledCommand? flutterInstalled,
    FlutterPubGetCommand? flutterPubGet,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
    FlutterGenL10nCommand? flutterGenL10n,
    FlutterFormatFixCommand? flutterFormatFix,
    GeneratorBuilder? generator,
  })  : _flutterInstalled = flutterInstalled ?? Flutter.installed,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterConfigEnableAndroid =
            flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
        _flutterConfigEnableIos =
            flutterConfigEnableIos ?? Flutter.configEnableIos,
        _flutterConfigEnableWeb =
            flutterConfigEnableWeb ?? Flutter.configEnableWeb,
        _flutterConfigEnableLinux =
            flutterConfigEnableLinux ?? Flutter.configEnableLinux,
        _flutterConfigEnableMacos =
            flutterConfigEnableMacos ?? Flutter.configEnableMacos,
        _flutterConfigEnableWindows =
            flutterConfigEnableWindows ?? Flutter.configEnableWindows,
        _flutterGenL10n = flutterGenL10n ?? Flutter.genl10n,
        _flutterFormatFix = flutterFormatFix ?? Flutter.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle,
        super(
          logger: logger ?? Logger(),
          command: Command.create,
        ) {
    argParser
      ..addSeparator('')
      ..addOption(
        'project-name',
        help: 'The project name for this new project. '
            'This must be a valid dart package name.',
      )
      ..addOption(
        'desc',
        help: 'The description for this new project.',
        defaultsTo: _defaultDescription,
      )
      ..addOrgNameOption(help: 'The organization for this new project.')
      ..addFlag(
        'example',
        help: 'This new project contains example features and their tests.',
        defaultsTo: _defaultExample,
      )
      ..addSeparator('')
      ..addPlatformFlags(
        platformGroupHelp: (platformGroup) =>
            'Wheter this new project supports the ${platformGroup.platforms.prettyEnumeration} platforms.',
        platformHelp: (platform) =>
            'Wheter this new project supports the ${platform.prettyName} platform.',
      );
  }

  final FlutterInstalledCommand _flutterInstalled;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableAndroid;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableIos;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWeb;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableLinux;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableMacos;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWindows;
  final FlutterGenL10nCommand _flutterGenL10n;
  final FlutterFormatFixCommand _flutterFormatFix;
  final GeneratorBuilder _generator;

  @override
  String get description =>
      'Creates a new Scalable project in the specified directory.';

  @override
  String get invocation => '${super.invocation} <output directory>';

  @override
  List<String> get aliases => ['c'];

  @override
  Future<int> run() async {
    final isFlutterInstalled = await _flutterInstalled();
    if (!isFlutterInstalled) {
      logger.err('Flutter not installed.');

      return ExitCode.unavailable.code;
    }

    final outputDirectory = _outputDirectory;

    bool android = super.android;
    bool ios = super.ios;
    bool web = super.web;
    bool linux = super.linux;
    bool macos = super.macos;
    bool windows = super.windows;
    final any = android || ios || web || linux || macos || windows;
    if (!any) {
      android = true;
      ios = true;
      web = true;
      linux = true;
      macos = true;
      windows = true;
    }

    if (android) {
      final enableAndroidProgress = logger.progress(
        'Running "flutter config --enable-android"',
      );
      await _flutterConfigEnableAndroid();
      enableAndroidProgress.complete();
    }
    if (ios) {
      final enableIosProgress = logger.progress(
        'Running "flutter config --enable-ios"',
      );
      await _flutterConfigEnableIos();
      enableIosProgress.complete();
    }
    if (web) {
      final enableWebProgress = logger.progress(
        'Running "flutter config --enable-web"',
      );
      await _flutterConfigEnableWeb();
      enableWebProgress.complete();
    }
    if (linux) {
      final enableLinuxProgress = logger.progress(
        'Running "flutter config --enable-linux-desktop"',
      );
      await _flutterConfigEnableLinux();
      enableLinuxProgress.complete();
    }
    if (macos) {
      final enableMacosProgress = logger.progress(
        'Running "flutter config --enable-macos-desktop"',
      );
      await _flutterConfigEnableMacos();
      enableMacosProgress.complete();
    }
    if (windows) {
      final enableWindowsProgress = logger.progress(
        'Running "flutter config --enable-windows-desktop"',
      );
      await _flutterConfigEnableWindows();
      enableWindowsProgress.complete();
    }

    final generateProgress = logger.progress('Bootstrapping');
    final generator = await _generator(scalableCoreBundle);
    final files = await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: <String, dynamic>{
        'project_name': _projectName,
        'description': _description,
        'cupertino_icons_version': cupertinoIconsVersion,
        'macos_ui_version': macosUiVersion,
        'fluent_ui_version': fluentUiVersion,
        'yaru_version': yaruVersion,
        'yaru_icons_version': yaruIconsVersion,
        'org_name': orgName,
        'example': _example,
        'android': android,
        'ios': ios,
        'web': web,
        'linux': linux,
        'macos': macos,
        'windows': windows,
      },
      logger: logger,
    );
    generateProgress.complete('Generated ${files.length} file(s)');

    final installDependenciesProgress = logger.progress(
      'Running "flutter pub get" in ${outputDirectory.path}',
    );
    await _flutterPubGet(cwd: outputDirectory.path);
    installDependenciesProgress.complete();

    final generateLocalizationsProgress = logger.progress(
      'Running "flutter gen-l10n" in ${outputDirectory.path}',
    );
    await _flutterGenL10n(cwd: outputDirectory.path);
    generateLocalizationsProgress.complete();

    final formatProgress = logger.progress(
      'Running "flutter format . --fix" in ${outputDirectory.path}',
    );
    await _flutterFormatFix(cwd: outputDirectory.path);
    formatProgress.complete();

    logger
      ..info('\n')
      ..alert('Created a Scalable App!')
      ..info('\n');

    return ExitCode.success.code;
  }

  /// Gets the directory where the project will be generated in specified by the user.
  Directory get _outputDirectory =>
      _validateOutputDirectoryArg(argResults.rest);

  /// Gets the project name specified by the user.
  ///
  /// Uses the current directory path name
  /// if the `--project-name` option is not explicitly specified.
  String get _projectName => _validateProjectName(argResults['project-name'] ??
      p.basename(p.normalize(_outputDirectory.absolute.path)));

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;

  /// Whether the user specified that the project will contain example pages, blocs, services etc.
  bool get _example => argResults['example'] ?? _defaultExample;

  /// Validates whether [name] is valid project name.
  ///
  /// Returns [name] when valid.
  String _validateProjectName(String name) {
    final isValid = _isValidPackageName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }
    return name;
  }

  /// Whether [name] is valid project name.
  bool _isValidPackageName(String name) {
    final match = _identifierRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  /// Validates wheter [args] contains exactly one path to a directory.
  ///
  /// Returns the directory.
  Directory _validateOutputDirectoryArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the output directory.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple output directories specified.', usage);
    }

    return Directory(args.first);
  }
}
