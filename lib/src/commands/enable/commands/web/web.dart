part of '../commands.dart';

/// {@template enable_web_command}
/// `scalable enable web` command adds support for Web to an existing Scalable project.
/// {@endtemplate}
class WebCommand extends EnableSubCommand {
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
          flutterFormatFix: flutterFormatFix ?? Flutter.formatFix,
          platform: Platform.web,
          bundle: webBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        );

  @override
  Map<String, dynamic> get vars => {'description': _description};

  /// Gets the description.
  String get _description => pubspec.description ?? '';
}
