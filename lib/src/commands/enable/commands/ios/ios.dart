part of '../commands.dart';

/// {@template enable_ios_command}
/// `scalable enable ios` command adds support for iOS to an existing Scalable project.
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
