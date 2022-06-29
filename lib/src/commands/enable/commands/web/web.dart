part of '../commands.dart';

/// {@template enable_web_command}
/// `scalable enable web` command adds support for Web to this project.
/// {@endtemplate}
class WebCommand extends PlatformCommand {
  WebCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    Set<MainFile>? mains,
    InjectionConfigFile? injectionConfig,
    InjectionTestFile? injectableTest,
    IsEnabledInProject? isEnabledInProject,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    FlutterFormatFixCommand? flutterFormatFix,
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
              flutterConfigEnableWeb ?? Flutter.configEnableWeb,
          flutterFormatFixCommand: flutterFormatFix ?? Flutter.formatFix,
          platform: Platform.web,
          bundle: webBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        );

  @override
  Map<String, dynamic> get vars => {'description': _description};

  // TODO should this be nullable is mason output fine then when null?

  /// Gets the description.
  String? get _description => pubspec.description;
}

// TODO remove
/*
 class WebCommand extends Command<int> {
   /// {@macro enable_web_command}
   WebCommand({
     Logger? logger,
     FlutterConfigEnableWebCommand? flutterConfigEnableWeb,
     FlutterFormatFixCommand? flutterFormatFixCommand,
     GeneratorBuilder? generator,
   })  : _logger = logger ?? Logger(),
         _flutterConfigEnableWeb =
             flutterConfigEnableWeb ?? Flutter.configEnableWeb,
         _flutterFormatFixCommand = flutterFormatFixCommand ?? Flutter.formatFix,
         _generator = generator ?? MasonGenerator.fromBundle;
 
   final Logger _logger;
   final FlutterConfigEnableWebCommand _flutterConfigEnableWeb;
   final FlutterFormatFixCommand _flutterFormatFixCommand;
   final GeneratorBuilder _generator;
 
   @override
   String get description => 'Adds support for Web to this project.';
 
   @override
   String get summary => '$invocation\n$description';
 
   @override
   String get name => 'web';
 
   @override
   String get invocation => 'scalable enable web';
 
   @override
   Future<int> run() async {
     final runDone = _logger.progress(
       '''Enabling ${lightYellow.wrap('Web')}''',
     );
 
     await _flutterConfigEnableWeb();
 
     if (_project.isEnabled(Platform.web)) {
       runDone('${lightYellow.wrap('Web')} already enabled.');
 
       return ExitCode.success.code;
     }
 
     final projectName = _projectName;
     final description = _description;
 
     final generator = await _generator(webBundle);
     await generator.generate(
       DirectoryGeneratorTarget(_project.rootDir),
       vars: <String, dynamic>{
         'project_name': projectName,
         'description': description,
       },
       logger: _logger,
     );
 
     _project.mainDevelopment.addPlatform(Platform.web);
     _project.mainTest.addPlatform(Platform.web);
     _project.mainProduction.addPlatform(Platform.web);
     _project.injectionConfig.addRouter(Platform.web);
     _project.injectableTest.addRouterTest(Platform.web);
     await _flutterFormatFixCommand();
 
     runDone('''Enabled ${lightYellow.wrap('Web')}''');
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
 
   // TODO should this be nullable is mason output fine then?
   String? get _description => _project.pubspec.description;
 }
 */
