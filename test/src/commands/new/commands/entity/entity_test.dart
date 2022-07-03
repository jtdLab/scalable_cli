import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scalable_cli/src/commands/new/commands/commands.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds new entity + tests to this project.\n'
      '\n'
      'Usage: scalable new entity\n'
      '-h, --help          Print this usage information.\n'
      '-o, --output-dir    The output directory inside lib/domain/.\n'
      '                    (defaults to "")\n'
      '\n'
      'Run "scalable help" to see global options.'
];

class MockArgResults extends Mock implements ArgResults {}

class MockRootDir extends Mock implements RootDir {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class FakeLogger extends Fake implements Logger {}

void main() {
  group('entity', () {
    final cwd = Directory.current;

    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;

    final generatedFiles = List.filled(
      62,
      const GeneratedFile.created(path: ''),
    );

    setUpAll(() {
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
    });

    test('e is a valid alias', () {
      final command = EntityCommand();
      expect(command.aliases, contains('e'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['new', 'entity', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['new', 'entity', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = EntityCommand();
      expect(command, isNotNull);
    });

    test(
      'throws pubspec not found exception '
      'when no pubspec.yaml exists',
      withRunner((commandRunner, logger, printLogs) async {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final result = await commandRunner.run(['new', 'entity']);
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
      final command = EntityCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => root.directory).thenReturn(tempDir);
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
      verify(() => logger.progress('Generating MyEntity')).called(1);
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
            'path': 'domain',
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyEntity']);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ custom name', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;
      final argResults = MockArgResults();
      final root = MockRootDir();
      final pubspec = MockPubspecFile();
      final generator = MockMasonGenerator();
      final command = EntityCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults.arguments).thenReturn(['Custom']);
      when(() => root.directory).thenReturn(tempDir);
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
      verify(() => logger.progress('Generating CustomEntity')).called(1);
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
            'path': 'domain',
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated CustomEntity']);
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
      final command = EntityCommand(
        logger: logger,
        root: root,
        pubspec: pubspec,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['output-dir']).thenReturn('custom/dir');
      when(() => root.directory).thenReturn(tempDir);
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
      verify(() => logger.progress('Generating MyEntity')).called(1);
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
            'path': 'domain/custom/dir',
          },
          logger: logger,
        ),
      ).called(1);
      expect(progressLogs, ['Generated MyEntity']);
      expect(result, ExitCode.success.code);
    });
  });
}
