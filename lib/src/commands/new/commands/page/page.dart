part of '../commands.dart';

// TODO use platform getters mixin here

// TODO doc
const _defaultWidgets = true; // TODO good

/// {@template new_page_command}
/// `scalable new page` command creates a new page + test.
/// {@endtemplate}
class PageCommand extends ComponentCommand
    with PlatformGetters, PlatformGenerator {
  /// {@macro new_page_command}
  PageCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    IsEnabledInProject? isEnabledInProject,
    GeneratorBuilder? generator,
  })  : _isEnabledInProject = isEnabledInProject ?? Project.isEnabled,
        super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.page,
          bundle: pageBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser
      ..addOutputDirOption(
        help:
            'The output directory inside lib/presentation/**/ (** is the platform).',
      )
      ..addSeparator('')
      ..addPlatformFlags(
        platformGroupHelp: (platformGroup) =>
            'The page gets generated for ${platformGroup.platforms.prettyEnumeration}.',
        platformHelp: (platform) =>
            'The page gets generated for the ${platform.prettyName} platform.',
      )
      ..addSeparator('')
      ..addFlag(
        'widgets',
        help: 'Generate separate widgets.dart file for the page.',
        defaultsTo: _defaultWidgets,
      );
  }

  @override
  final IsEnabledInProject _isEnabledInProject;

  @override
  List<String> get aliases => ['p'];

  @override
  Map<String, dynamic> vars(Platform platform) => {
        'widgets': _widgets,
      };

  bool get _widgets => argResults['widgets'] ?? _defaultWidgets;
}
