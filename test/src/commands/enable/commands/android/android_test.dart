import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/enable/commands/commands.dart';
import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:scalable_cli/src/core/injection_test_file.dart';
import 'package:scalable_cli/src/core/main_file.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds support for Android to this project.\n'
      '\n'
      'Usage: scalable enable android\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the Android project.\n'
      '                  (defaults to "com.example")\n'
      '\n'
      'Run "scalable help" to see global options.'
];

// ignore: one_member_abstracts
abstract class IsEnabledInProject {
  bool call(Platform platform);
}

abstract class FlutterConfigEnablePlatformCommand {
  Future<void> call();
}

abstract class FlutterFormatFixCommand {
  Future<void> call({String cwd});
}

class MockArgResults extends Mock implements ArgResults {}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockRootDir extends Mock implements RootDir {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockMainFile extends Mock implements MainFile {}

class MockInjectionConfigFile extends Mock implements InjectionConfigFile {}

class MockInjectionTestFile extends Mock implements InjectionTestFile {}

class MockIsEnabledInProject extends Mock implements IsEnabledInProject {}

class MockFlutterConfigEnablePlatformCommand extends Mock
    implements FlutterConfigEnablePlatformCommand {}

class MockFlutterFormatFixCommand extends Mock
    implements FlutterFormatFixCommand {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class FakeLogger extends Fake implements Logger {}

void main() {
  group('android', () {
    final cwd = Directory.current;

    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;

    late IsEnabledInProject isEnabledInProject;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableAndroid;
    late FlutterFormatFixCommand flutterFormatFix;

    final generatedFiles = List.filled(
      62,
      const GeneratedFile.created(path: ''),
    );

    setUpAll(() {
      registerFallbackValue(Platform.android);
      registerFallbackValue(FakeDirectoryGeneratorTarget());
      registerFallbackValue(FakeLogger());
    });

    setUp(() {
      Directory.current = cwd;

      progressLogs = <String>[];

      logger = MockLogger();
      progress = MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
      when(() => logger.err(any())).thenReturn(null);

      isEnabledInProject = MockIsEnabledInProject();
      flutterConfigEnableAndroid = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableAndroid()).thenAnswer((_) async {});
      flutterFormatFix = MockFlutterFormatFixCommand();
      when(
        () => flutterFormatFix(cwd: any(named: 'cwd')),
      ).thenAnswer((_) async {});
    });

    test('a is a valid alias', () {
      final command = AndroidCommand();
      expect(command.aliases, contains('a'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['enable', 'android', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['enable', 'android', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = AndroidCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final directory = Directory.systemTemp.createTempSync();
        Directory.current = directory.path;
        final result = await commandRunner.run(['enable', 'android']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    // TODO generates .tmp dir
    test('completes successfully with correct output', () async {
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final main1 = MockMainFile();
      final main2 = MockMainFile();
      final injectionConfig = MockInjectionConfigFile();
      final injectionTest = MockInjectionTestFile();
      final flutterFormatFix = MockFlutterFormatFixCommand();
      final generator = MockMasonGenerator();
      final command = AndroidCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        mains: {main1, main2},
        injectionConfig: injectionConfig,
        injectableTest: injectionTest,
        isEnabledInProject: isEnabledInProject,
        flutterConfigEnableAndroid: flutterConfigEnableAndroid,
        flutterFormatFix: flutterFormatFix,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['org-name']).thenReturn(null);
      when(() => root.directory).thenReturn(Directory('.tmp'));
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => main1.addPlatform(Platform.android)).thenReturn(null);
      when(() => main2.addPlatform(Platform.android)).thenReturn(null);
      when(() => injectionConfig.addRouter(Platform.android)).thenReturn(null);
      when(() => injectionTest.addRouterTest(Platform.android))
          .thenReturn(null);
      when(() => isEnabledInProject(any())).thenReturn(false);
      when(() => flutterFormatFix()).thenAnswer((_) async {});
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);
      final result = await command.run();
      verify(() => isEnabledInProject(any())).called(1);
      verifyNever(() => logger.err('Android already enabled.'));
      verify(() => flutterConfigEnableAndroid()).called(1);
      verify(() => logger.progress('Enabling Android')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              '.tmp',
            ),
          ),
          vars: <String, dynamic>{
            'projectName': 'my_app',
            'org_name': 'com.example',
          },
          logger: logger,
        ),
      ).called(1);
      verify(() => main1.addPlatform(Platform.android)).called(1);
      verify(() => main2.addPlatform(Platform.android)).called(1);
      verify(() => injectionConfig.addRouter(Platform.android)).called(1);
      verify(() => injectionTest.addRouterTest(Platform.android)).called(1);
      verify(() => flutterFormatFix()).called(1);
      expect(progressLogs, ['Enabled Android']);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ custom org-name',
        () async {
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final main1 = MockMainFile();
      final main2 = MockMainFile();
      final injectionConfig = MockInjectionConfigFile();
      final injectionTest = MockInjectionTestFile();
      final flutterFormatFix = MockFlutterFormatFixCommand();
      final generator = MockMasonGenerator();
      final command = AndroidCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        mains: {main1, main2},
        injectionConfig: injectionConfig,
        injectableTest: injectionTest,
        isEnabledInProject: isEnabledInProject,
        flutterConfigEnableAndroid: flutterConfigEnableAndroid,
        flutterFormatFix: flutterFormatFix,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['org-name']).thenReturn('com.example.app');
      when(() => root.directory).thenReturn(Directory('.tmp'));
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => main1.addPlatform(Platform.android)).thenReturn(null);
      when(() => main2.addPlatform(Platform.android)).thenReturn(null);
      when(() => injectionConfig.addRouter(Platform.android)).thenReturn(null);
      when(() => injectionTest.addRouterTest(Platform.android))
          .thenReturn(null);
      when(() => isEnabledInProject(any())).thenReturn(false);
      when(() => flutterFormatFix()).thenAnswer((_) async {});
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles);
      final result = await command.run();
      verify(() => isEnabledInProject(any())).called(1);
      verifyNever(() => logger.err('Android already enabled.'));
      verify(() => flutterConfigEnableAndroid()).called(1);
      verify(() => logger.progress('Enabling Android')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              '.tmp',
            ),
          ),
          vars: <String, dynamic>{
            'projectName': 'my_app',
            'org_name': 'com.example.app',
          },
          logger: logger,
        ),
      ).called(1);
      verify(() => main1.addPlatform(Platform.android)).called(1);
      verify(() => main2.addPlatform(Platform.android)).called(1);
      verify(() => injectionConfig.addRouter(Platform.android)).called(1);
      verify(() => injectionTest.addRouterTest(Platform.android)).called(1);
      verify(() => flutterFormatFix()).called(1);
      expect(progressLogs, ['Enabled Android']);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when android is already enabled', () async {
      final command = AndroidCommand(
        logger: logger,
        isEnabledInProject: isEnabledInProject,
      );
      when(() => isEnabledInProject(any())).thenReturn(true);
      final result = await command.run();
      verify(() => logger.err('Android already enabled.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
