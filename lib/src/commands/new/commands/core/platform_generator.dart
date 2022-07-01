part of '../commands.dart';

// TODO doc
mixin PlatformGenerator on ComponentCommand, PlatformGetters {
  // TODO mobile and desktop doesnt work yet is not location sensitive doesnt care what platforms are enabled

  @override
  Future<int> run() => runWhenPubspecExists(() async {
        // TODO cleaner
        bool android = super.android;
        bool ios = super.ios;
        bool web = super.web;
        bool linux = super.linux;
        bool macos = super.macos;
        bool windows = super.windows;
        if (!(android || ios || web || linux || macos || windows)) {
          android = true;
          ios = true;
          web = true;
          linux = true;
          macos = true;
          windows = true;
        }

        final name = _name; // cleaner

        final runProgress = logger.progress(
          '''Generating ${lightYellow.wrap('$name${_component.name.pascalCase}')}''',
        );
        final androidFiles = await _generate(Platform.android, android);
        final iosFiles = await _generate(Platform.ios, ios);
        final webFiles = await _generate(Platform.web, web);
        final linuxFiles = await _generate(Platform.linux, linux);
        final macosFiles = await _generate(Platform.macos, macos);
        final windowsFiles = await _generate(Platform.windows, windows);
        runProgress.complete(
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
      });

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
