part of '../commands.dart';

/// {@template new_bloc_command}
/// `scalable create` command creates bloc + test.
/// {@endtemplate}
class BlocCommand extends ComponentCommand with SingleGenerator {
  /// {@macro new_bloc_command}
  BlocCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.bloc,
          bundle: blocBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOutputDirOption(
      help: 'The output directory inside lib/application/.',
    );
  }

  @override
  List<String> get aliases => ['b'];

  @override
  Map<String, dynamic> get vars => {
        'path': _path,
      };

  String get _path => p.join('application', _outputDir); // TODO
}
