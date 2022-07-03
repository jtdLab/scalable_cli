part of '../commands.dart';

/// {@template new_entity_command}
/// `scalable create` command creates a new entity + test.
/// {@endtemplate}
class EntityCommand extends NewSubCommand with SingleGenerator {
  /// {@macro new_entity_command}
  EntityCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.entity,
          bundle: entityBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOutputDirOption(
      help: 'The output directory inside lib/domain/.',
    );
  }

  @override
  List<String> get aliases => ['e'];

  @override
  Map<String, dynamic> get vars => {
        'path': _path,
      };

  String get _path => p.join('domain', _outputDir);
}
