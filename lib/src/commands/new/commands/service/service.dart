part of '../commands.dart';

/// {@template new_service_command}
/// `scalable create` command creates a new service + fake impl + test.
/// {@endtemplate}
class ServiceCommand extends ComponentCommand with SingleGenerator {
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

  String get _domainPath => p.join('domain', _outputDir); // TODO

  String get _infrastructurePath =>
      p.join('infrastructure', _outputDir); // TODO
}

// TODO remove
/*
 class ServiceCommand extends Command<int> {
   /// {@macro new_service_command}
   ServiceCommand({
     Logger? logger,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _generator = generator ?? MasonGenerator.fromBundle {
     argParser.addOption(
       'output-dir',
       help: 'The output directory inside lib/domain/.',
       abbr: 'o',
       defaultsTo: '',
     );
   }
 
   final Logger _logger;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds new service to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'service';
 
   @override
   String get invocation => 'scalable new service';
 
   @override
   List<String> get aliases => ['s'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final outputDirectory = _outputDirectory;
     final projectName = _projectName;
     final name = _name;
     final domainPath = _domainPath;
     final infrastructurePath = _infrastructurePath;
 
     final runDone = _logger.progress(
       '''Generating ${lightYellow.wrap('${name}Service')}''',
     );
     final generator = await _generator(serviceBundle);
     final files = await generator.generate(
       DirectoryGeneratorTarget(outputDirectory),
       vars: <String, dynamic>{
         'project_name': projectName,
         'name': name,
         'domain_path': domainPath,
         'infrastructure_path': infrastructurePath,
       },
       logger: _logger,
     );
     runDone('''Generated ${lightYellow.wrap('${name}Service')}''');
     _logger.info('');
     for (final file in files) {
       _logger.success(p.relative(file.path, from: _project.rootDir.path));
     }
     _logger.info('');
 
     return ExitCode.success.code;
   }
 
   Directory get _outputDirectory => _project.rootDir;
 
   String get _projectName => _project.pubspec.name;
 
   String get _name {
     try {
       return _argResults.arguments.first.pascalCase;
     } catch (_) {
       return 'My';
     }
   }
 
   String get _domainPath => p.join('domain', _argResults['output-dir']);
 
   String get _infrastructurePath =>
       p.join('infrastructure', _argResults['output-dir']);
 }
 */
