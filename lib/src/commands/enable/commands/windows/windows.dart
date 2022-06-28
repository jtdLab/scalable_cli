part of '../commands.dart';

/// {@template enable_windows_command}
/// `scalable enable windows` command adds support for Windows to this project.
/// {@endtemplate}
class WindowsCommand extends PlatformCommand
    with TestableArgResults, OrgNameGetters {
  WindowsCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    Set<MainFile>? mains,
    InjectionConfigFile? injectionConfig,
    InjectionTestFile? injectableTest,
    IsEnabledInProject? isEnabledInProject,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
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
              flutterConfigEnableWindows ?? Flutter.configEnableWindows,
          flutterFormatFixCommand: flutterFormatFixCommand ?? Flutter.formatFix,
          platform: Platform.windows,
          bundle: windowsBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the ${_platform.prettyName} project.',
    );
  }

  final FlutterPubGetCommand _flutterPubGet;

  @override
  List<String> get aliases => ['win'];

  @override
  Map<String, dynamic> get vars => {'org_name': orgName};

  @override
  Future<void> preGenerateHook() async {
    pubspec.addDependency('fluent_ui', fluentUiVersion);
    await _flutterPubGet(cwd: _root.path);
  }
}

// TODO remove
/*
 class WindowsCommand extends Command<int> {
   /// {@macro enable_windows_command}
   WindowsCommand({
     Logger? logger,
     FlutterConfigEnableWindowsCommand? flutterConfigEnableWindows,
     FlutterPubGetCommand? flutterPubGetCommand,
     FlutterFormatFixCommand? flutterFormatFixCommand,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _flutterConfigEnableWindows =
             flutterConfigEnableWindows ?? Flutter.configEnableWindows,
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
   final FlutterConfigEnableWindowsCommand _flutterConfigEnableWindows;
   final FlutterPubGetCommand _flutterPubGetCommand;
   final FlutterFormatFixCommand _flutterFormatFixCommand;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds support for Windows to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'windows';
 
   @override
   String get invocation => 'scalable enable windows';
 
   @override
   List<String> get aliases => ['win'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final runDone = _logger.progress(
       '''Enabling ${lightYellow.wrap('Windows')}''',
     );
 
     await _flutterConfigEnableWindows();
 
     if (_project.isEnabled(Platform.windows)) {
       runDone('${lightYellow.wrap('Windows')} already enabled.');
 
       return ExitCode.success.code;
     }
 
     final projectName = _projectName;
     final orgName = _orgName;
 
     // TODO keep version up to date
     _project.pubspec.addDependency('fluent_ui', '^3.12.0');
     await _flutterPubGetCommand(cwd: _project.rootDir.path);
 
     final generator = await _generator(windowsBundle);
     await generator.generate(
       DirectoryGeneratorTarget(_project.rootDir),
       vars: <String, dynamic>{
         'project_name': projectName,
         'org_name': orgName,
       },
       logger: _logger,
     );
 
     _project.mainDevelopment.addPlatform(Platform.windows);
     _project.mainTest.addPlatform(Platform.windows);
     _project.mainProduction.addPlatform(Platform.windows);
     _project.injectionConfig.addRouter(Platform.windows);
     _project.injectableTest.addRouterTest(Platform.windows);
     await _flutterFormatFixCommand();
 
     runDone('''Enabled ${lightYellow.wrap('Windows')}''');
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
