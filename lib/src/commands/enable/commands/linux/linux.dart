part of '../commands.dart';

/// {@template enable_linux_command}
/// `scalable enable linux` command adds support for Linux to this project.
/// {@endtemplate}
class LinuxCommand extends PlatformCommand
    with TestableArgResults, OrgNameGetters {
  LinuxCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    Set<MainFile>? mains,
    InjectionConfigFile? injectionConfig,
    InjectionTestFile? injectableTest,
    IsEnabledInProject? isEnabledInProject,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
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
              flutterConfigEnableLinux ?? Flutter.configEnableLinux,
          flutterFormatFixCommand: flutterFormatFix ?? Flutter.formatFix,
          platform: Platform.linux,
          bundle: linuxBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the ${_platform.prettyName} project.',
    );
  }

  final FlutterPubGetCommand _flutterPubGet;

  @override
  List<String> get aliases => ['lin', 'l'];

  @override
  Map<String, dynamic> get vars => {'org_name': orgName};

  @override
  Future<void> preGenerateHook() async {
    pubspec.addDependency('yaru', yaruVersion);
    pubspec.addDependency('yaru_icons', yaruIconsVersion);
    await _flutterPubGet(cwd: _root.path);
  }
}

// TODO remove
/*
 class LinuxCommand extends Command<int> {
   /// {@macro enable_linux_command}
   LinuxCommand({
     Logger? logger,
     FlutterConfigEnableLinuxCommand? flutterConfigEnableLinux,
     FlutterPubGetCommand? flutterPubGetCommand,
     FlutterFormatFixCommand? flutterFormatFixCommand,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _flutterConfigEnableLinux =
             flutterConfigEnableLinux ?? Flutter.configEnableLinux,
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
   final FlutterConfigEnableLinuxCommand _flutterConfigEnableLinux;
   final FlutterPubGetCommand _flutterPubGetCommand;
   final FlutterFormatFixCommand _flutterFormatFixCommand;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds support for Linux to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'linux';
 
   @override
   String get invocation => 'scalable enable linux';
 
   @override
   List<String> get aliases => ['lin', 'l'];
 
   /// [ArgResults] which can be overridden for testing.
   @visibleForTesting
   ArgResults? argResultOverrides;
 
   ArgResults get _argResults => argResultOverrides ?? argResults!;
 
   @override
   Future<int> run() async {
     final runDone = _logger.progress(
       '''Enabling ${lightYellow.wrap('Linux')}''',
     );
 
     await _flutterConfigEnableLinux();
 
     if (_project.isEnabled(Platform.linux)) {
       runDone('${lightYellow.wrap('Linux')} already enabled.');
 
       return ExitCode.success.code;
     }
 
     final projectName = _projectName;
     final orgName = _orgName;
 
     // TODO keep version up to date
     _project.pubspec.addDependency('yaru', '^0.3.0');
     _project.pubspec.addDependency('yaru_icons', '^0.2.1');
     await _flutterPubGetCommand(cwd: _project.rootDir.path);
 
     final generator = await _generator(linuxBundle);
     await generator.generate(
       DirectoryGeneratorTarget(_project.rootDir),
       vars: <String, dynamic>{
         'project_name': projectName,
         'org_name': orgName,
       },
       logger: _logger,
     );
 
     _project.mainDevelopment.addPlatform(Platform.linux);
     _project.mainTest.addPlatform(Platform.linux);
     _project.mainProduction.addPlatform(Platform.linux);
     _project.injectionConfig.addRouter(Platform.linux);
     _project.injectableTest.addRouterTest(Platform.linux);
     await _flutterFormatFixCommand();
 
     runDone('''Enabled ${lightYellow.wrap('Linux')}''');
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
