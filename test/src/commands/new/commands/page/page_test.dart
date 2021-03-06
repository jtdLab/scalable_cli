import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds new page + tests to this project.\n'
      '\n'
      'Usage: scalable new page\n'
      '-h, --help            Print this usage information.\n'
      '-o, --output-dir      The output directory inside lib/presentation/**/ (** is the platform).\n'
      '                      (defaults to "")\n'
      '\n'
      '\n'
      '    --mobile          The page gets generated for Android and iOS.\n'
      '    --desktop         The page gets generated for Linux, macOS and Windows.\n'
      '    --android         The page gets generated for the Android platform.\n'
      '    --ios             The page gets generated for the iOS platform.\n'
      '    --web             The page gets generated for the Web platform.\n'
      '    --linux           The page gets generated for the Linux platform.\n'
      '    --macos           The page gets generated for the macOS platform.\n'
      '    --windows         The page gets generated for the Windows platform.\n'
      '\n'
      '\n'
      '    --[no-]widgets    Generate separate widgets.dart file for the page.\n'
      '                      (defaults to on)\n'
      '\n'
      'Run "scalable help" to see global options.'
];

// ignore: one_member_abstracts
abstract class IsEnabledInProject {
  bool call(Platform platform);
}

class MockArgResults extends Mock implements ArgResults {}

class MockRootDir extends Mock implements RootDir {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class FakeLogger extends Fake implements Logger {}

class MockIsEnabledInProject extends Mock implements IsEnabledInProject {}

void main() {
  group('page', () {
    final cwd = Directory.current;

    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;

    late IsEnabledInProject isEnabledInProject;

    List<GeneratedFile> generatedFiles(String rootPath) => [
          GeneratedFile.created(path: '$rootPath/generated/file'),
        ];

    setUpAll(() {
      registerFallbackValue(Platform.ios);
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
      when(() => isEnabledInProject(any())).thenReturn(true);
    });

    test('p is a valid alias', () {
      final command = PageCommand();
      expect(command.aliases, contains('p'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['new', 'page', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['new', 'page', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = PageCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final result = await commandRunner.run(['new', 'page']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'android',
            'android': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'ios',
            'ios': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'web',
            'web': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'linux',
            'linux': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'macos',
            'macos': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'windows',
            'windows': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Android:')).called(1);
      verify(() => logger.info('iOS:')).called(1);
      verify(() => logger.info('Web:')).called(1);
      verify(() => logger.info('Linux:')).called(1);
      verify(() => logger.info('macOS:')).called(1);
      verify(() => logger.info('Windows:')).called(1);
      verify(() => logger.success('generated/file')).called(6);
      verify(
        () => logger.info(
          'Register here: lib/presentation/android/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/ios/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/web/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/linux/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/macos/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/windows/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(13);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when no platforms are enabled', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => isEnabledInProject(any())).thenReturn(false);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(() => progress.cancel()).called(1);
      verify(() => logger.err('No platform enabled.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('completes successfully with correct output w/ custom name', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults.arguments).thenReturn(['Custom']);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating CustomPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'Custom',
            'path': 'android',
            'android': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'Custom',
            'path': 'ios',
            'ios': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'Custom',
            'path': 'web',
            'web': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'Custom',
            'path': 'linux',
            'linux': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'Custom',
            'path': 'macos',
            'macos': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'Custom',
            'path': 'windows',
            'windows': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated CustomPage']);
      verify(() => logger.info('Android:')).called(1);
      verify(() => logger.info('iOS:')).called(1);
      verify(() => logger.info('Web:')).called(1);
      verify(() => logger.info('Linux:')).called(1);
      verify(() => logger.info('macOS:')).called(1);
      verify(() => logger.info('Windows:')).called(1);
      verify(() => logger.success('generated/file')).called(6);
      verify(
        () => logger.info(
          'Register here: lib/presentation/android/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/ios/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/web/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/linux/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/macos/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/windows/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(13);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ custom output-dir',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['output-dir']).thenReturn('custom/dir');
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'android/custom/dir',
            'android': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'ios/custom/dir',
            'ios': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'web/custom/dir',
            'web': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'linux/custom/dir',
            'linux': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'macos/custom/dir',
            'macos': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'windows/custom/dir',
            'windows': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Android:')).called(1);
      verify(() => logger.info('iOS:')).called(1);
      verify(() => logger.info('Web:')).called(1);
      verify(() => logger.info('Linux:')).called(1);
      verify(() => logger.info('macOS:')).called(1);
      verify(() => logger.info('Windows:')).called(1);
      verify(() => logger.success('generated/file')).called(6);
      verify(
        () => logger.info(
          'Register here: lib/presentation/android/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/ios/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/web/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/linux/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/macos/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/windows/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(13);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output when --mobile, --desktop and --web is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['mobile']).thenReturn(true);
      when(() => argResults['desktop']).thenReturn(true);
      when(() => argResults['web']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'android',
            'android': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'ios',
            'ios': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'web',
            'web': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'linux',
            'linux': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'macos',
            'macos': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'windows',
            'windows': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Android:')).called(1);
      verify(() => logger.info('iOS:')).called(1);
      verify(() => logger.info('Web:')).called(1);
      verify(() => logger.info('Linux:')).called(1);
      verify(() => logger.info('macOS:')).called(1);
      verify(() => logger.info('Windows:')).called(1);
      verify(() => logger.success('generated/file')).called(6);
      verify(
        () => logger.info(
          'Register here: lib/presentation/android/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/ios/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/web/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/linux/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/macos/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/windows/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(13);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output when --mobile is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['mobile']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'android',
            'android': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'ios',
            'ios': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Android:')).called(1);
      verify(() => logger.info('iOS:')).called(1);
      verify(() => logger.success('generated/file')).called(2);
      verify(
        () => logger.info(
          'Register here: lib/presentation/android/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/ios/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(5);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output when --desktop is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['desktop']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'linux',
            'linux': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'macos',
            'macos': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'windows',
            'windows': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Linux:')).called(1);
      verify(() => logger.info('macOS:')).called(1);
      verify(() => logger.info('Windows:')).called(1);
      verify(() => logger.success('generated/file')).called(3);
      verify(
        () => logger.info(
          'Register here: lib/presentation/linux/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/macos/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/windows/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(7);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output when --android is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['android']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'android',
            'android': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Android:')).called(1);
      verify(() => logger.success('generated/file')).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/android/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(3);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output when --ios is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['ios']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'ios',
            'ios': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('iOS:')).called(1);
      verify(() => logger.success('generated/file')).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/ios/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(3);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output when --web is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['web']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'web',
            'web': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Web:')).called(1);
      verify(() => logger.success('generated/file')).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/web/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(3);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output when --linux is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['linux']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'linux',
            'linux': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Linux:')).called(1);
      verify(() => logger.success('generated/file')).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/linux/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(3);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output when --macos is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['macos']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'macos',
            'macos': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('macOS:')).called(1);
      verify(() => logger.success('generated/file')).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/macos/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(3);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output when --windows is selected',
        () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['windows']).thenReturn(true);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'windows',
            'windows': true,
            'widgets': true,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Windows:')).called(1);
      verify(() => logger.success('generated/file')).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/windows/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(3);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ no-widgets', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = PageCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        isEnabledInProject: isEnabledInProject,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['widgets']).thenReturn(false);
      when(() => root.directory).thenReturn(tempDir);
      when(() => root.path).thenReturn(tempDir.path);
      when(() => pubspec.exists).thenReturn(true);
      when(() => pubspec.name).thenReturn('my_app');
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async => generatedFiles(tempDir.path));
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'android',
            'android': true,
            'widgets': false,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'ios',
            'ios': true,
            'widgets': false,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'web',
            'web': true,
            'widgets': false,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'linux',
            'linux': true,
            'widgets': false,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'macos',
            'macos': true,
            'widgets': false,
          },
          logger: logger,
        ),
      ).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              tempDir.path,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': 'my_app',
            'name': 'My',
            'path': 'windows',
            'windows': true,
            'widgets': false,
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyPage']);
      verify(() => logger.info('Android:')).called(1);
      verify(() => logger.info('iOS:')).called(1);
      verify(() => logger.info('Web:')).called(1);
      verify(() => logger.info('Linux:')).called(1);
      verify(() => logger.info('macOS:')).called(1);
      verify(() => logger.info('Windows:')).called(1);
      verify(() => logger.success('generated/file')).called(6);
      verify(
        () => logger.info(
          'Register here: lib/presentation/android/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/ios/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/web/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/linux/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/macos/core/router.dart',
        ),
      ).called(1);
      verify(
        () => logger.info(
          'Register here: lib/presentation/windows/core/router.dart',
        ),
      ).called(1);
      verify(() => logger.info('')).called(13);
      expect(result, ExitCode.success.code);
    });
  });
}
