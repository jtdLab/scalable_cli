import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:scalable_cli/src/cli/cli.dart';
import 'package:scalable_cli/src/commands/core/dependency_versions.dart';
import 'package:scalable_cli/src/commands/core/generator_builder.dart';
import 'package:scalable_cli/src/commands/core/is_enabled_in_project.dart';
import 'package:scalable_cli/src/commands/core/logging.dart';
import 'package:scalable_cli/src/commands/core/org_name_option.dart';
import 'package:scalable_cli/src/commands/core/overridable_arg_results.dart';
import 'package:scalable_cli/src/commands/core/pubspec_required.dart';
import 'package:scalable_cli/src/commands/enable/commands/android/android_bundle.dart';
import 'package:scalable_cli/src/commands/enable/commands/ios/ios_bundle.dart';
import 'package:scalable_cli/src/commands/enable/commands/linux/linux_bundle.dart';
import 'package:scalable_cli/src/commands/enable/commands/macos/macos_bundle.dart';
import 'package:scalable_cli/src/commands/enable/commands/web/web_bundle.dart';
import 'package:scalable_cli/src/commands/enable/commands/windows/windows_bundle.dart';
import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:scalable_cli/src/core/injection_test_file.dart';
import 'package:scalable_cli/src/core/main_file.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';

part 'android/android.dart';
part 'ios/ios.dart';
part 'linux/linux.dart';
part 'macos/macos.dart';
part 'web/web.dart';
part 'windows/windows.dart';

/// {@template enable_sub_command}
/// Base class for all enable sub commands.
/// {@endtemplate}
abstract class EnableSubCommand extends Command<int>
    with Logging, PubspecRequired {
  /// {@macro enable_sub_command}
  EnableSubCommand({
    required this.logger,
    required RootDir root,
    required this.pubspec,
    required Set<MainFile> mains,
    required InjectionConfigFile injectionConfig,
    required InjectionTestFile injectableTest,
    required IsEnabledInProject isEnabledInProject,
    required FlutterConfigEnablePlatformCommand flutterConfigEnablePlatform,
    required FlutterFormatFixCommand flutterFormatFix,
    required Platform platform,
    required MasonBundle bundle,
    required GeneratorBuilder generator,
  })  : _root = root,
        _mains = mains,
        _injectionConfig = injectionConfig,
        _injectableTest = injectableTest,
        _isEnabledInProject = isEnabledInProject,
        _flutterConfigEnablePlatform = flutterConfigEnablePlatform,
        _flutterFormatFix = flutterFormatFix,
        _platform = platform,
        _bundle = bundle,
        _generator = generator;

  @override
  final Logger logger;
  final RootDir _root;
  @override
  final PubspecFile pubspec;
  final Set<MainFile> _mains;
  final InjectionConfigFile _injectionConfig;
  final InjectionTestFile _injectableTest;
  final IsEnabledInProject _isEnabledInProject;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnablePlatform;
  final FlutterFormatFixCommand _flutterFormatFix;
  final Platform _platform;
  final MasonBundle _bundle;
  final GeneratorBuilder _generator;

  @override
  String get description =>
      'Adds support for ${_platform.prettyName} to this project.';

  @override
  String get summary => '$invocation\n$description';

  @override
  String get name => _platform.name;

  @override
  String get invocation => 'scalable enable $name';

  @override
  Future<int> run() => runWhenPubspecExists(() async {
        final platformIsEnabled = _isEnabledInProject(_platform);
        if (platformIsEnabled) {
          logger.err('${_platform.prettyName} already enabled.');

          return ExitCode.config.code;
        }

        await _flutterConfigEnablePlatform();
        final runProgress = logger.progress(
          'Enabling ${lightYellow.wrap(_platform.prettyName)}',
        );
        await preGenerateHook();
        final generator = await _generator(_bundle);
        await generator.generate(
          DirectoryGeneratorTarget(_root.directory),
          vars: {
            'project_name': _projectName,
            ...vars,
          },
          logger: logger,
        );

        for (final main in _mains) {
          // TODO catch errors and print pretty information to user about corrput main file and what its is expected to look like
          main.addPlatform(_platform);
        }
        _injectionConfig.addRouter(_platform);
        _injectableTest.addRouterTest(_platform);
        await _flutterFormatFix();
        runProgress.complete(
          'Enabled ${lightYellow.wrap(_platform.prettyName)}',
        );

        // TODO keep or remove
        // logger.info('');
        // logger.info('Register here:');
        // logger.info('');
        // logger.info(
        //   '${styleBold.wrap(lightYellow.wrap('main_development.dart'))}',
        // );
        // logger.info(
        //   '${styleBold.wrap(lightYellow.wrap('main_production.dart'))}',
        // );
        // logger.info(
        //   '${styleBold.wrap(lightYellow.wrap('main_test.dart'))}',
        // );
        // logger.info('');

        return ExitCode.success.code;
      });

  /// Gets the vars of the [bundle].
  Map<String, dynamic> get vars;

  /// Gets the project name.
  String get _projectName => pubspec.name;

  /// Hook that runs before files from mason templates get generated
  Future<void> preGenerateHook() async => {};
}
