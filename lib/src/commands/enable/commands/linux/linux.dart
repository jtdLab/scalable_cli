part of '../commands.dart';

/// {@template enable_linux_command}
/// `scalable enable linux` command adds support for Linux to an existing Scalable project.
/// {@endtemplate}
class LinuxCommand extends PlatformCommand
    with OverridableArgResults, OrgNameGetters {
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
          flutterFormatFix: flutterFormatFix ?? Flutter.formatFix,
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
