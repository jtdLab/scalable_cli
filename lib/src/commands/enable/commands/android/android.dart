part of '../commands.dart';

/// {@template enable_macos_command}
/// `scalable enable android` command adds support for Android to an existing Scalable project.
/// {@endtemplate}
class AndroidCommand extends PlatformCommand
    with OverridableArgResults, OrgNameGetters {
  AndroidCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    Set<MainFile>? mains,
    InjectionConfigFile? injectionConfig,
    InjectionTestFile? injectableTest,
    IsEnabledInProject? isEnabledInProject,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
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
              flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
          flutterFormatFix: flutterFormatFix ?? Flutter.formatFix,
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
