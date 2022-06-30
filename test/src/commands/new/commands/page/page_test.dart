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

    final generatedFiles = List.filled(
      1,
      const GeneratedFile.created(path: '.tmp/generated/file'),
    );

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
        final directory = Directory.systemTemp.createTempSync();
        Directory.current = directory.path;
        final result = await commandRunner.run(['new', 'page']);
        expect(result, equals(ExitCode.noInput.code));
        verify(() {
          logger.err(any(that: contains('Could not find a pubspec.yaml in')));
        }).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
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
      when(() => root.directory).thenReturn(Directory('.tmp'));
      when(() => root.path).thenReturn('.tmp');
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
      ).thenAnswer((_) async => generatedFiles);
      final result = await command.run();
      verify(() => logger.progress('Generating MyPage')).called(1);
      verify(() => isEnabledInProject(Platform.android)).called(1);
      verify(() => isEnabledInProject(Platform.ios)).called(1);
      verify(() => isEnabledInProject(Platform.web)).called(1);
      verify(() => isEnabledInProject(Platform.linux)).called(1);
      verify(() => isEnabledInProject(Platform.macos)).called(1);
      verify(() => isEnabledInProject(Platform.windows)).called(1);
      // TODO use seperate method
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
              '.tmp',
            ),
          ),
          vars: <String, dynamic>{
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
              '.tmp',
            ),
          ),
          vars: <String, dynamic>{
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
              '.tmp',
            ),
          ),
          vars: <String, dynamic>{
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
              '.tmp',
            ),
          ),
          vars: <String, dynamic>{
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
              '.tmp',
            ),
          ),
          vars: <String, dynamic>{
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

    // TODO more granular tests for params and some edge cases
  });
}
