part of '../commands.dart';

/// {@template enable_macos_command}
/// `scalable enable macos` command adds support for macOS to this project.
/// {@endtemplate}
class MacosCommand extends PlatformCommand
    with TestableArgResults, OrgNameGetters {
  MacosCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    Set<MainFile>? mains,
    InjectionConfigFile? injectionConfig,
    InjectionTestFile? injectableTest,
    IsEnabledInProject? isEnabledInProject,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
    FlutterPubGetCommand? flutterPubGet,
    FlutterFormatFixCommand? flutterFormatFixCommand,
    GeneratorBuilder? generator,
  })  : _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          mains: mains ?? Project.mains,
          injectionConfig: injectionConfig ?? Project.injectionConfig,
          injectableTest: injectableTest ?? Project.injectionTest,
          isEnabledInProject: isEnabledInProject ?? Project.isEnabled,
          flutterConfigEnablePlatform:
              flutterConfigEnableMacos ?? Flutter.configEnableMacos,
          flutterFormatFixCommand: flutterFormatFixCommand ?? Flutter.formatFix,
          platform: Platform.macos,
          bundle: macosBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the ${_platform.prettyName} project.',
    );
  }

  final FlutterPubGetCommand _flutterPubGet;

  @override
  List<String> get aliases => ['mac', 'm'];

  @override
  Map<String, dynamic> get vars => {'org_name': orgName};

  @override
  Future<void> preGenerateHook() async {
    _pubspec.addDependency('cupertino_icons', cupertinoIconsVersion);
    _pubspec.addDependency('macos_ui', macosUiVersion);
    await _flutterPubGet(cwd: _root.path);
  }
}

// TODO remove
/*
 class MacosCommand extends Command<int> {
   /// {@macro enable_macos_command}
   MacosCommand({
     Logger? logger,
     FlutterConfigEnableMacosCommand? flutterConfigEnableMacos,
     FlutterPubGetCommand? flutterPubGetCommand,
     FlutterFormatFixCommand? flutterFormatFixCommand,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _flutterConfigEnableMacos =
             flutterConfigEnableMacos ?? Flutter.configEnableMacos,
         _flutterPubGetCommand = flutterPubGetCommand ?? Flutter.pubGet,
         _flutterFormatFixCommand = flutterFormatFixCommand ?? Flutter.formatFix,
         _generator = generator ?? MasonGenerator.fromBundle {
     argParser.addOption(
       'org-name',
       help: 'The organization for the android project.',
       defaultsTo: _defaultOrgName,
       aliases: ['org'],
     );
   }
 
   final Logger _logger;
   final FlutterConfigEnableMacosCommand _flutterConfigEnableMacos;
   final FlutterPubGetCommand _flutterPubGetCommand;
   final FlutterFormatFixCommand _flutterFormatFixCommand;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds support for macOS to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'macos';
 
   @override
   String get invocation => 'scalable enable macos';
 
   @override
   List<String> get aliases => ['mac', 'm'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final runDone = _logger.progress(
       '''Enabling ${lightYellow.wrap('macOS')}''',
     );
 
     await _flutterConfigEnableMacos();
 
     if (_project.isEnabled(Platform.macos)) {
       runDone('${lightYellow.wrap('macOS')} already enabled.');
 
       return ExitCode.success.code;
     }
 
     final projectName = _projectName;
     final orgName = _orgName;
 
     // TODO keep version up to date
     _project.pubspec.addDependency('macos_ui', '^1.4.0');
     await _flutterPubGetCommand(cwd: _project.rootDir.path);
 
     final generator = await _generator(macosBundle);
     await generator.generate(
       DirectoryGeneratorTarget(_project.rootDir),
       vars: <String, dynamic>{
         'project_name': projectName,
         'org_name': orgName,
       },
       logger: _logger,
     );
 
     _project.mainDevelopment.addPlatform(Platform.macos);
     _project.mainTest.addPlatform(Platform.macos);
     _project.mainProduction.addPlatform(Platform.macos);
     _project.injectionConfig.addRouter(Platform.macos);
     _project.injectableTest.addRouterTest(Platform.macos);
     await _flutterFormatFixCommand();
 
     runDone('''Enabled ${lightYellow.wrap('macOS')}''');
     _logger.info('');
     // _logger.info('Register here:');
     // _logger.info('');
     // _logger.info(
     //   '${styleBold.wrap(lightYellow.wrap('main_development.dart'))}',
     // );
     // _logger.info(
     //   '${styleBold.wrap(lightYellow.wrap('main_production.dart'))}',
     // );
     // _logger.info(
     //   '${styleBold.wrap(lightYellow.wrap('main_test.dart'))}',
     // );
     // _logger.info('');
 
     return ExitCode.success.code;
   }
 
   /// Gets the project name.
   String get _projectName => _project.pubspec.name;
 
   /// Gets the organization name.
   String get _orgName => _validateOrgName(_argResults['org-name']);
 
   String _validateOrgName(String name) {
     final isValid = isValidOrgName(name);
     if (!isValid) {
       throw InvalidOrgName(name, usage);
     }
     return name;
   }
 }
 */
