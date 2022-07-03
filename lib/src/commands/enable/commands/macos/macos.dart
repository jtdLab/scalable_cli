part of '../commands.dart';

/// {@template enable_macos_command}
/// `scalable enable macos` command adds support for macOS to an existing Scalable project.
/// {@endtemplate}
class MacosCommand extends EnableSubCommand
    with OverridableArgResults, OrgNameGetters {
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
              flutterConfigEnableMacos ?? Flutter.configEnableMacos,
          flutterFormatFix: flutterFormatFix ?? Flutter.formatFix,
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
    pubspec.addDependency('cupertino_icons', cupertinoIconsVersion);
    pubspec.addDependency('macos_ui', macosUiVersion);
    await _flutterPubGet(cwd: _root.path);
  }
}
