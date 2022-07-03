part of '../commands.dart';

/// {@template new_flow_command}
/// `scalable new flow` command creates a new flow + test.
/// {@endtemplate}
class FlowCommand extends NewSubCommand
    with PlatformGetters, PlatformGenerator {
  /// {@macro new_flow_command}
  FlowCommand({
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
          component: Component.flow,
          bundle: flowBundle,
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
            'The flow gets generated for ${platformGroup.platforms.prettyEnumeration}.',
        platformHelp: (platform) =>
            'The flow gets generated for the ${platform.prettyName} platform.',
      );
  }

  @override
  final IsEnabledInProject _isEnabledInProject;

  @override
  List<String> get aliases => ['f'];
}
