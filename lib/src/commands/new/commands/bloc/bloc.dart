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

// TODO remove
/*
 class BlocCommand extends Command<int> {
   /// {@macro new_bloc_command}
   BlocCommand({
     Logger? logger,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _generator = generator ?? MasonGenerator.fromBundle {
     argParser.addOption(
       'output-dir',
       help: 'The output directory inside lib/application/.',
       abbr: 'o',
       defaultsTo: '',
     );
   }
 
   final Logger _logger;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds new bloc to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'bloc';
 
   @override
   String get invocation => 'scalable new bloc';
 
   @override
   List<String> get aliases => ['b'];
 
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
 
     final runDone = _logger.progress(
       '''Generating ${lightYellow.wrap('${name}Bloc')}''',
     );
     final generator = await _generator(blocBundle);
     final files = await generator.generate(
       DirectoryGeneratorTarget(outputDirectory),
       vars: <String, dynamic>{
         'project_name': projectName,
         'name': name,
         'path': path,
       },
       logger: _logger,
     );
     runDone('''Generated ${lightYellow.wrap('${name}Bloc')}''');
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
 
   String get _path => p.join('application', _argResults['output-dir']);
 }
 */
