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
        help: 'The entity this dto belongs to.',
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

  String get _path => p.join('infrastructure', _outputDir); // TODO

  String get _entity =>
      argResults['entity'] ?? _name; // TODO _name good if null?
}

// TODO remove
/*
 class DtoCommand extends Command<int> {
   /// {@macro new_dto_command}
   DtoCommand({
     Logger? logger,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _generator = generator ?? MasonGenerator.fromBundle {
     argParser
       ..addOption(
         'output-dir',
         help: 'The output directory inside lib/infrastructure/.',
         abbr: 'o',
         defaultsTo: '',
       )
       ..addSeparator('')
       ..addOption(
         'entity',
         help: 'The entity this dto belongs to.',
         abbr: 'e',
       );
   }
 
   final Logger _logger;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds new data transfer object to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'dto';
 
   @override
   String get invocation => 'scalable new dto';
 
   @override
   List<String> get aliases => ['d'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final outputDirectory = _outputDirectory;
     final projectName = _projectName;
     final name = _name;
     final path = _path;
     final entity = _entity;
 
     final runDone = _logger.progress(
       '''Generating ${lightYellow.wrap('${name}Dto')}''',
     );
     final generator = await _generator(dtoBundle);
     final files = await generator.generate(
       DirectoryGeneratorTarget(outputDirectory),
       vars: <String, dynamic>{
         'project_name': projectName,
         'name': name,
         'path': path,
         'entity': entity,
       },
       logger: _logger,
     );
     runDone('''Generated ${lightYellow.wrap('${name}Dto')}''');
     _logger.info('');
     for (final file in files) {
       _logger.success(p.relative(file.path, from: outputDirectory.path));
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
 
   String get _path {
     return p.join('infrastructure', _argResults['output-dir']);
   }
 
   String get _entity => _argResults['entity'] ?? _name;
 }
 */
