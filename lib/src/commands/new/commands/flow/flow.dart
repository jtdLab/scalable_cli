part of '../commands.dart';

/// {@template new_flow_command}
/// `scalable new flow` command creates a new flow + test.
/// {@endtemplate}
class FlowCommand extends ComponentCommand
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
        platformGroupHelp: (platformGroup) => 'The flow gets generated for '
            '${platformGroup == PlatformGroup.all ? 'all enabled platforms' : platformGroup.platforms.prettyEnumeration}.',
        platformHelp: (platform) =>
            'The flow gets generated for the ${platform.prettyName} platform.',
      );
  }

  @override
  final IsEnabledInProject _isEnabledInProject;

  @override
  List<String> get aliases => ['f'];
}

// TODO remove
/*
 class FlowCommand2 extends Command<int> {
   /// {@macro new_flow_command}
   FlowCommand2({
     Logger? logger,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _generator = generator ?? MasonGenerator.fromBundle {
     argParser
       ..addOption(
         'output-dir',
         help:
             'The output directory inside lib/presentation/**/ (** is the platform).',
         abbr: 'o',
         defaultsTo: '',
       )
       ..addSeparator('')
       ..addFlag(
         'all',
         help: 'The flow gets generated for all enabled platforms.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'mobile',
         help:
             'The flow gets generated for the Android and iOS platform if enabled.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'desktop',
         help:
             'The flow gets generated for the macOS, Windows and Linux platform if enabled.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'android',
         help: 'The flow gets generated for the Android platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'ios',
         help: 'The flow gets generated for the iOS platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'web',
         help: 'The flow gets generated for the Web platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'linux',
         help: 'The flow gets generated for the Linux platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'macos',
         help: 'The flow gets generated for the macOS platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'windows',
         help: 'The flow gets generated for the Windows platform.',
         negatable: false,
         defaultsTo: false,
       );
   }
 
   final Logger _logger;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds new flow to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'flow';
 
   @override
   String get invocation => 'scalable new flow';
 
   @override
   List<String> get aliases => ['f'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final name = _name;
     final runDone = _logger.progress(
       '''Generating ${lightYellow.wrap('${name}Flow')}''',
     );
     final all = _argResults['all'] as bool;
     final mobile = _argResults['mobile'] as bool;
     final desktop = _argResults['desktop'] as bool;
     final android = _argResults['android'] as bool;
     final ios = _argResults['ios'] as bool;
     final web = _argResults['web'] as bool;
     final linux = _argResults['linux'] as bool;
     final macos = _argResults['macos'] as bool;
     final windows = _argResults['windows'] as bool;
 
     final anyPlatform = all ||
         mobile ||
         desktop ||
         android ||
         ios ||
         web ||
         linux ||
         macos ||
         windows;
 
     if (!anyPlatform) {
       // TODO usage of this command pls
       throw UsageException('No platform chosen.', usage);
     }
 
     final androidFiles = await _generate(Platform.android);
     final iosFiles = await _generate(Platform.ios);
     final webFiles = await _generate(Platform.web);
     final linuxFiles = await _generate(Platform.linux);
     final macosFiles = await _generate(Platform.macos);
     final windowsFiles = await _generate(Platform.windows);
 
     runDone('''Generated ${lightYellow.wrap('${name}Flow')}''');
 
     _logger.info('');
     _logGenerateResults(androidFiles, 'Android:', 'android');
     _logGenerateResults(iosFiles, 'iOS:', 'ios');
     _logGenerateResults(webFiles, 'Web:', 'web');
     _logGenerateResults(linuxFiles, 'Linux:', 'linux');
     _logGenerateResults(macosFiles, 'macOS:', 'macos');
     _logGenerateResults(windowsFiles, 'Windows:', 'windows');
 
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
 
   Future<List<GeneratedFile>?> _generate(Platform platform) async {
     final allRequestedByUser = _argResults['all'] as bool;
     final requestedByUser = _argResults[platform.name] as bool;
     final enabledInProject = _project.isEnabled(platform);
     final willGenerate =
         (allRequestedByUser || requestedByUser) && enabledInProject;
     if (!willGenerate) {
       return null;
     }
 
     final projectName = _projectName;
     final name = _name;
     final path = p.join(platform.name, _argResults['output-dir']);
 
     final generator = await _generator(flowBundle);
 
     return await generator.generate(
       DirectoryGeneratorTarget(_outputDirectory),
       vars: <String, dynamic>{
         'project_name': projectName,
         'name': name,
         'path': path,
         platform.name: true,
       },
       logger: _logger,
     );
   }
 
   void _logGenerateResults(
     List<GeneratedFile>? files,
     String title,
     String platform,
   ) {
     if (files == null) {
       return;
     }
 
     void printPaths(List<GeneratedFile> files) {
       for (final file in files) {
         _logger.success(p.relative(file.path, from: _outputDirectory.path));
       }
     }
 
     _logger.info(title);
     printPaths(files);
     _logger.info('');
     _logger.info(
       'Register here: ${styleBold.wrap(lightYellow.wrap('lib/presentation/$platform/core/router.dart'))}',
     );
     _logger.info('');
   }
 }
 */
