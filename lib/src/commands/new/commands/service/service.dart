part of '../commands.dart';

/// {@template new_service_command}
/// `scalable create` command creates a new service + fake impl + test.
/// {@endtemplate}
class ServiceCommand extends NewSubCommand with SingleGenerator {
  /// {@macro new_service_command}
  ServiceCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.service,
          bundle: serviceBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOutputDirOption(
      help: 'The output directory inside lib/domain/.',
    );
  }

  @override
  List<String> get aliases => ['s'];

  @override
  Map<String, dynamic> get vars => {
        'domain_path': _domainPath,
        'infrastructure_path': _infrastructurePath,
      };

  String get _domainPath => p.join('domain', _outputDir);

  String get _infrastructurePath => p.join('infrastructure', _outputDir);
}
