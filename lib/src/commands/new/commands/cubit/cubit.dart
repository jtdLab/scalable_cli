part of '../commands.dart';

/// {@template new_cubit_command}
/// `scalable create` command creates a cubit + test.
/// {@endtemplate}
class CubitCommand extends ComponentCommand with SingleGenerator {
  /// {@macro new_cubit_command}
  CubitCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.cubit,
          bundle: cubitBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOutputDirOption(
      help: 'The output directory inside lib/application/.',
    );
  }

  @override
  List<String> get aliases => ['c'];

  @override
  Map<String, dynamic> get vars => {
        'path': _path,
      };

  String get _path => p.join('application', _outputDir); // TODO
}
