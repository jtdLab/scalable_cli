part of '../commands.dart';

/// {@template new_dto_command}
/// `scalable create` command creates a new dto + test.
/// {@endtemplate}
class DtoCommand extends ComponentCommand with SingleGenerator {
  /// {@macro new_dto_command}
  DtoCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.dto,
          bundle: dtoBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser
      ..addOutputDirOption(
        help: 'The output directory inside lib/infrastructure/.',
      )
      ..addSeparator('')
      ..addOption(
        'entity',
        help: 'The entity this data transfer object belongs to.',
        abbr: 'e',
      );
  }

  @override
  List<String> get aliases => ['d'];

  @override
  Map<String, dynamic> get vars => {
        'path': _path,
        'entity': _entity,
      };

  String get _path => p.join('infrastructure', _outputDir);

  String get _entity => argResults['entity'] ?? _name;
}
