part of '../commands.dart';

/// {@template enable_macos_command}
/// `scalable enable android` command adds support for Android to this project.
/// {@endtemplate}
class AndroidCommand extends PlatformCommand
    with TestableArgResults, OrgNameGetters {
  AndroidCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    Set<MainFile>? mains,
    InjectionConfigFile? injectionConfig,
    InjectionTestFile? injectableTest,
    IsEnabledInProject? isEnabledInProject,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    FlutterFormatFixCommand? flutterFormatFixCommand,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          mains: mains ?? Project.mains,
          injectionConfig: injectionConfig ?? Project.injectionConfig,
          injectableTest: injectableTest ?? Project.injectionTest,
          isEnabledInProject: isEnabledInProject ?? Project.isEnabled,
          flutterConfigEnablePlatform:
              flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
          flutterFormatFixCommand: flutterFormatFixCommand ?? Flutter.formatFix,
          platform: Platform.android,
          bundle: androidBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the ${_platform.prettyName} project.',
    );
  }

  @override
  List<String> get aliases => ['a'];

  @override
  Map<String, dynamic> get vars => {'org_name': orgName};
}

// TODO remove
/*
 /// {@template enable_android_command}
 /// `scalable enable android` command adds support for Android to this project.
 /// {@endtemplate}
 class AndroidCommand extends Command<int> {
   /// {@macro enable_android_command}
   AndroidCommand({
     Logger? logger,
     Directory? root,
     PubspecFile? pubspec,
     Set<MainFile>? mains,
     InjectionConfigFile? injectionConfig,
     InjectableTestFile? injectableTest,
     IsEnabledInProject? isEnabledInProject,
     FlutterConfigEnableAndroidCommand? flutterConfigEnableAndroid,
     FlutterFormatFixCommand? flutterFormatFixCommand,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _root = root ?? Project2.rootDir,
         _pubspec = pubspec ?? Project2.pubspec,
         _mains = mains ?? Project2.mains,
         _injectionConfig = injectionConfig ?? Project2.injectionConfig,
         _injectableTest = injectableTest ?? Project2.injectableTest,
         _isEnabledInProject = isEnabledInProject ?? Project2.isEnabled,
         _flutterConfigEnableAndroid =
             flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
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
   final Directory _root;
   PubspecFile _pubspec;
   final Set<MainFile> _mains;
   InjectionConfigFile _injectionConfig;
   InjectableTestFile _injectableTest;
   final IsEnabledInProject _isEnabledInProject;
   final FlutterConfigEnableAndroidCommand _flutterConfigEnableAndroid;
   final FlutterFormatFixCommand _flutterFormatFixCommand;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds support for Android to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'android';
 
   @override
   String get invocation => 'scalable enable android';
 
   @override
   List<String> get aliases => ['a'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final runDone = _logger.progress(
       '''Enabling ${lightYellow.wrap('Android')}''',
     );
 
     await _flutterConfigEnableAndroid(); // TODO is this good
 
     if (_isEnabledInProject(Platform.android)) {
       runDone('${lightYellow.wrap('Android')} already enabled.');
 
       return ExitCode.success.code;
     }
 
     final projectName = _projectName;
     final orgName = _orgName;
 
     final generator = await _generator(androidBundle);
     await generator.generate(
       DirectoryGeneratorTarget(_root),
       vars: <String, dynamic>{
         'project_name': projectName,
         'org_name': orgName,
       },
       logger: _logger,
     );
 
     for (final main in _mains) {
       main.addPlatform(Platform.android);
     }
     _injectionConfig.addRouter(Platform.android);
     _injectableTest.addRouterTest(Platform.android);
 
     await _flutterFormatFixCommand();
 
     runDone('''Enabled ${lightYellow.wrap('Android')}''');
     _logger.info('');
     // TODO
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
   String get _projectName => _pubspec.name;
 
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
