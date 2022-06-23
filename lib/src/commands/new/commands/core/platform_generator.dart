part of '../commands.dart';

// TODO share with create
class NoPlatformChosen extends UsageException {
  NoPlatformChosen(String usage) : super('No platform chosen.', usage);
}

mixin PlatformGenerator on ComponentCommand, PlatformGetters {
  // TODO mobile and desktop deosnt work yet is not location sensitive doest care what platforms are enabled

  @override
  Future<int> run() => cwdContainsPubspec(
        onContainsPubspec: () async {
          if (!(android || ios || web || linux || macos || windows)) {
            throw NoPlatformChosen(usage);
          }

          final name = _name;

          final runDone = logger.progress(
            '''Generating ${lightYellow.wrap('$name${_component.name.pascalCase}')}''',
          );
          final androidFiles = await _generate(Platform.android, android);
          final iosFiles = await _generate(Platform.ios, ios);
          final webFiles = await _generate(Platform.web, web);
          final linuxFiles = await _generate(Platform.linux, linux);
          final macosFiles = await _generate(Platform.macos, macos);
          final windowsFiles = await _generate(Platform.windows, windows);
          runDone(
            '''Generated ${lightYellow.wrap('$name${_component.name.pascalCase}')}''',
          );

          logger.info('');
          _logGenerateResults(androidFiles, 'Android:', 'android');
          _logGenerateResults(iosFiles, 'iOS:', 'ios');
          _logGenerateResults(webFiles, 'Web:', 'web');
          _logGenerateResults(linuxFiles, 'Linux:', 'linux');
          _logGenerateResults(macosFiles, 'macOS:', 'macos');
          _logGenerateResults(windowsFiles, 'Windows:', 'windows');

          return ExitCode.success.code;
        },
      );

  IsEnabledInProject get _isEnabledInProject;

  String _path(Platform platform) => p.join(platform.name, _outputDir);

  /// Gets the vars of the [bundle].
  Map<String, dynamic> vars(Platform platform) => {};

  Future<List<GeneratedFile>?> _generate(
    Platform platform,
    bool requestedByUser,
  ) async {
    final enabledInProject = _isEnabledInProject(platform);
    if (!(requestedByUser && enabledInProject)) {
      return null;
    }

    final generator = await _generator(pageBundle);
    return await generator.generate(
      DirectoryGeneratorTarget(_root.directory),
      vars: <String, dynamic>{
        'path': _path(platform),
        platform.name: true,
        ...vars(platform),
      },
      logger: logger,
    );
  }

  void _logGenerateResults(
    List<GeneratedFile>? files,
    String title,
    String platform,
  ) {
    if (files == null) {
      return;
    }

    logger.info(title);
    for (final file in files) {
      logger.success(p.relative(file.path, from: _root.path));
    }
    logger.info('');
    logger.info(
      'Register here: ${styleBold.wrap(lightYellow.wrap('lib/presentation/$platform/core/router.dart'))}',
    );
    logger.info('');
  }
}
