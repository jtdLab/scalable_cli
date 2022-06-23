part of '../commands.dart';

const _defaultType = 'MyType';

/// {@template new_value_object_command}
/// `scalable create` command creates a new value object + test.
/// {@endtemplate}
class ValueObjectCommand extends ComponentCommand with SingleGenerator {
  /// {@macro new_value_object_command}
  ValueObjectCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.valueObject,
          bundle: valueObjectBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser
      ..addOutputDirOption(help: 'The output directory inside lib/domain/.')
      ..addSeparator('')
      ..addOption(
        'type',
        help: 'The type that gets wrapped by this value object.\n'
            'Generics get escaped via "#" e.g Tuple<#A, #B, String>.',
        defaultsTo: _defaultType,
      );
  }

  @override
  List<String> get aliases => ['vo'];

  @override
  Map<String, dynamic> get vars => {
        'path': _path,
        'type': _type,
        'generics': _generics,
      };

  String get _path => p.join('domain', _outputDir);

  String get _type => argResults['type'].replaceAll('#', ''); // TODO works ?

  String get _generics {
    final raw =
        argResults['type'] ?? _defaultType; // TODO why not take _type ??
    StringBuffer buffer = StringBuffer();
    buffer.write('<');

    final generics = raw
        .split(RegExp('[,<>]'))
        .where((element) => element.startsWith('#'))
        .map((element) => element.replaceAll('#', ''))
        .toList();

    for (int i = 0; i < generics.length; i++) {
      buffer.write(generics[i]);
      if (i != generics.length - 1) {
        buffer.write(',');
      }
    }

    buffer.write('>');

    final string = buffer.toString();

    if (string == '<>') {
      return '';
    }

    return buffer.toString();
  }
}

/*
 class ValueObjectCommand extends Command<int> {
   /// {@macro new_value_object_command}
   ValueObjectCommand({
     Logger? logger,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _generator = generator ?? MasonGenerator.fromBundle {
     argParser
       ..addOption(
         'output-dir',
         help: 'The output directory inside lib/domain/.',
         abbr: 'o',
         defaultsTo: '',
       )
       ..addOption(
         'type',
         help:
             'The type that gets wrapped by this value object.\nGenerics get escaped via "#" e.g Tuple<#A, #B, String>.',
         defaultsTo: _defaultType,
       );
   }
 
   final Logger _logger;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds new value object to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'value_object';
 
   @override
   String get invocation => 'scalable new value_object';
 
   @override
   List<String> get aliases => ['vo'];
 
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
     final type = _type;
     final generics = _generics;
 
     final runDone = _logger.progress(
       '''Generating ${lightYellow.wrap(name)}''',
     );
     final generator = await _generator(valueObjectBundle);
     final files = await generator.generate(
       DirectoryGeneratorTarget(outputDirectory),
       vars: <String, dynamic>{
         'project_name': projectName,
         'name': name,
         'path': path,
         'type': type,
         'generics': generics,
       },
       logger: _logger,
     );
     runDone('''Generated ${lightYellow.wrap(name)}''');
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
 
   String get _path => p.join('domain', _argResults['output-dir']);
 
   String get _type => (_argResults['type'] ?? 'MyType').replaceAll('#', '');
 
   String get _generics {
     final raw = _argResults['type'] ?? 'MyType';
     StringBuffer buffer = StringBuffer();
     buffer.write('<');
 
     final generics = raw
         .split(RegExp('[,<>]'))
         .where((element) => element.startsWith('#'))
         .map((element) => element.replaceAll('#', ''))
         .toList();
 
     for (int i = 0; i < generics.length; i++) {
       buffer.write(generics[i]);
       if (i != generics.length - 1) {
         buffer.write(',');
       }
     }
 
     buffer.write('>');
 
     final string = buffer.toString();
 
     if (string == '<>') {
       return '';
     }
 
     return buffer.toString();
   }
 }
 */
