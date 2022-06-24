part of '../commands.dart';

// TODO use platform getters mixin here

/// {@template new_page_command}
/// `scalable new page` command creates a new page + test.
/// {@endtemplate}
class PageCommand extends ComponentCommand
    with PlatformGetters, PlatformGenerator {
  /// {@macro new_page_command}
  PageCommand({
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
          component: Component.page,
          bundle: pageBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser
      ..addOutputDirOption(
        help:
            'The output directory inside lib/presentation/**/ (** is the platform).',
      )
      ..addSeparator('')
      ..addPlatformFlags(
        platformGroupHelp: (platformGroup) =>
            'The page gets generated for ${platformGroup.platforms.prettyEnumeration}.',
        platformHelp: (platform) =>
            'The page gets generated for the ${platform.prettyName} platform.',
      )
      ..addSeparator('')
      ..addFlag(
        'widgets',
        help: 'Generate separate widgets.dart file for the page.',
        defaultsTo: true,
      );
  }

  @override
  final IsEnabledInProject _isEnabledInProject;

  @override
  List<String> get aliases => ['p'];

  @override
  Map<String, dynamic> vars(Platform platform) => {
        'widgets': _widgets,
      };

  bool get _widgets => argResults['widgets'];
}

// TODO remove
/*
 class PageCommand2 extends Command<int> {
   /// {@macro new_page_command}
   PageCommand2({
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
         help: 'The page gets generated for all enabled platforms.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'mobile',
         help:
             'The page gets generated for the Android and iOS platform if enabled.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'desktop',
         help:
             'The page gets generated for the macOS, Windows and Linux platform if enabled.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'android',
         help: 'The page gets generated for the Android platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'ios',
         help: 'The page gets generated for the iOS platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'web',
         help: 'The page gets generated for the Web platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'linux',
         help: 'The page gets generated for the Linux platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'macos',
         help: 'The page gets generated for the macOS platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addFlag(
         'windows',
         help: 'The page gets generated for the Windows platform.',
         negatable: false,
         defaultsTo: false,
       )
       ..addSeparator('')
       ..addFlag(
         'widgets',
         help: 'Generate separate widgets.dart file for the page.',
         defaultsTo: true,
       );
   }
 
   final Logger _logger;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds new page to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'page';
 
   @override
   String get invocation => 'scalable new page';
 
   @override
   List<String> get aliases => ['p'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final name = _name;
     final runDone = _logger.progress(
       '''Generating ${lightYellow.wrap('${name}Page')}''',
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
 
     runDone('''Generated ${lightYellow.wrap('${name}Page')}''');
 
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
     final widgets = _argResults['widgets'] as bool;
 
     final generator = await _generator(pageBundle);
 
     return await generator.generate(
       DirectoryGeneratorTarget(_outputDirectory),
       vars: <String, dynamic>{
         'project_name': projectName,
         'name': name,
         'path': path,
         'widgets': widgets,
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
