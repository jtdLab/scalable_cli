part of '../commands.dart';

/// {@template enable_ios_command}
/// `scalable enable ios` command adds support for iOS to this project.
/// {@endtemplate}
class IosCommand extends PlatformCommand
    with OverridableArgResults, OrgNameGetters {
  IosCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    Set<MainFile>? mains,
    InjectionConfigFile? injectionConfig,
    InjectionTestFile? injectableTest,
    IsEnabledInProject? isEnabledInProject,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    FlutterPubGetCommand? flutterPubGet,
    FlutterFormatFixCommand? flutterFormatFix,
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
              flutterConfigEnableIos ?? Flutter.configEnableIos,
          flutterFormatFixCommand: flutterFormatFix ?? Flutter.formatFix,
          platform: Platform.ios,
          bundle: iosBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the ${_platform.prettyName} project.',
    );
  }

  final FlutterPubGetCommand _flutterPubGet;

  @override
  List<String> get aliases => ['i'];

  @override
  Map<String, dynamic> get vars => {'org_name': orgName};

  @override
  Future<void> preGenerateHook() async {
    pubspec.addDependency('cupertino_icons', cupertinoIconsVersion);
    await _flutterPubGet(cwd: _root.path);
  }
}

// TODO remove
/*
 class IosCommand extends Command<int> {
   /// {@macro enable_ios_command}
   IosCommand({
     Logger? logger,
     FlutterConfigEnableIosCommand? flutterConfigEnableIos,
     FlutterPubGetCommand? flutterPubGetCommand,
     FlutterFormatFixCommand? flutterFormatFixCommand,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _flutterConfigEnableIos =
             flutterConfigEnableIos ?? Flutter.configEnableIos,
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
   final FlutterConfigEnableIosCommand _flutterConfigEnableIos;
   final FlutterPubGetCommand _flutterPubGetCommand;
   final FlutterFormatFixCommand _flutterFormatFixCommand;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds support for iOS to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'ios';
 
   @override
   String get invocation => 'scalable enable ios';
 
   @override
   List<String> get aliases => ['i'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final runDone = _logger.progress(
       '''Enabling ${lightYellow.wrap('iOS')}''',
     );
 
     await _flutterConfigEnableIos();
 
     if (_project.isEnabled(Platform.ios)) {
       runDone('${lightYellow.wrap('iOS')} already enabled.');
 
       return ExitCode.success.code;
     }
 
     final projectName = _projectName;
     final orgName = _orgName;
 
     // TODO keep version up to date
     _project.pubspec.addDependency('cupertino_icons', '^1.0.4');
     await _flutterPubGetCommand(cwd: _project.rootDir.path);
 
     final generator = await _generator(iosBundle);
     await generator.generate(
       DirectoryGeneratorTarget(_project.rootDir),
       vars: <String, dynamic>{
         'project_name': projectName,
         'org_name': orgName,
       },
       logger: _logger,
     );
 
     _project.mainDevelopment.addPlatform(Platform.ios);
     _project.mainTest.addPlatform(Platform.ios);
     _project.mainProduction.addPlatform(Platform.ios);
     _project.injectionConfig.addRouter(Platform.ios);
     _project.injectableTest.addRouterTest(Platform.ios);
     await _flutterFormatFixCommand();
 
     runDone('''Enabled ${lightYellow.wrap('iOS')}''');
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
