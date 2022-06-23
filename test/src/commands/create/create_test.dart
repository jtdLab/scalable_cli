import 'dart:async';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:pub_updater/pub_updater.dart';
import 'package:scalable_cli/src/commands/create/create.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Creates a new Scalable project in the specified directory.\n'
      '\n'
      'Usage: scalable create <output directory>\n'
      '-h, --help            Print this usage information.\n'
      '\n'
      '\n'
      '    --project-name    The project name for this new project. This must be a valid dart package name.\n'
      '    --desc            The description for this new project.\n'
      '                      (defaults to "A Scalable app.")\n'
      '    --org-name        The organization for this new project.\n'
      '                      (defaults to "com.example")\n'
      '    --[no-]example    This new project contains example features and their tests.\n'
      '                      (defaults to on)\n'
      '\n'
      '\n'
      '    --all             Wheter this new project supports the Android, iOS, Web, Linux, macOS and Windows platform.\n'
      '    --mobile          Wheter this new project supports the Android and iOS platform.\n'
      '    --desktop         Wheter this new project supports the Linux, macOS and Windows platform.\n'
      '    --android         Wheter this new project supports the Android platform.\n'
      '    --ios             Wheter this new project supports the iOS platform.\n'
      '    --web             Wheter this new project supports the Web platform.\n'
      '    --linux           Wheter this new project supports the Linux platform.\n'
      '    --macos           Wheter this new project supports the macOS platform.\n'
      '    --windows         Wheter this new project supports the Windows platform.\n'
      '\n'
      'Run "scalable help" to see global options.'
];

const pubspec = '''
name: example
environment:
  sdk: ">=2.13.0 <3.0.0"
''';

class MockArgResults extends Mock implements ArgResults {}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockPubUpdater extends Mock implements PubUpdater {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class FakeLogger extends Fake implements Logger {}

void main() {
  group('create', () {
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
      progressLogs = <String>[];

      logger = MockLogger();
      progress = MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        final result = await commandRunner.run(['create', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['create', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      final command = CreateCommand();
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when --project-name is missing '
      'and directory base is not a valid package name',
      withRunner((commandRunner, logger, printLogs) async {
        const expectedErrorMessage = '".tmp" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';
        final result = await commandRunner.run(['create', '.tmp']);
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when --project-name is invalid',
      withRunner((commandRunner, logger, printLogs) async {
        const expectedErrorMessage = '"My App" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';
        final result = await commandRunner.run(
          ['create', '.', '--project-name', 'My App'],
        );
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when output directory is missing',
      withRunner((commandRunner, logger, printLogs) async {
        const expectedErrorMessage =
            'No option specified for the output directory.';
        final result = await commandRunner.run(['create']);
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when multiple output directories are provided',
      withRunner((commandRunner, logger, printLogs) async {
        const expectedErrorMessage = 'Multiple output directories specified.';
        final result = await commandRunner.run(['create', './a', './b']);
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      final argResults = MockArgResults();
      final generator = MockMasonGenerator();
      final command = CreateCommand(
        logger: logger,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['project-name'] as String?).thenReturn('my_app');
      when(() => argResults.rest).thenReturn(['.tmp']);
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async {
        File(p.join('.tmp', 'pubspec.yaml')).writeAsStringSync(pubspec);
        return generatedFiles;
      });
      final result = await command.run();
      expect(result, equals(ExitCode.success.code));
      verify(() => logger.progress('Bootstrapping')).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(
        () => logger.progress('Running "flutter packages get" in .tmp'),
      ).called(1);
      verify(() => logger.alert('Created a Scalable App!')).called(1);
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
            'project_name': 'my_app',
            'org_name': 'com.example',
            'description': '',
            'android': true,
            'ios': true,
            'web': true,
            'linux': true,
            'macos': true,
            'windows': true,
          },
          logger: logger,
        ),
      ).called(1);
    });

    test('completes successfully w/ custom description', () async {
      final argResults = MockArgResults();
      final generator = MockMasonGenerator();
      final command = CreateCommand(
        logger: logger,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['project-name'] as String?).thenReturn('my_app');
      when(
        () => argResults['desc'] as String?,
      ).thenReturn('some description');
      when(() => argResults.rest).thenReturn(['.tmp']);
      when(() => generator.id).thenReturn('generator_id');
      when(() => generator.description).thenReturn('generator description');
      when(
        () => generator.generate(
          any(),
          vars: any(named: 'vars'),
          logger: any(named: 'logger'),
        ),
      ).thenAnswer((_) async {
        File(p.join('.tmp', 'pubspec.yaml')).writeAsStringSync(pubspec);
        return generatedFiles;
      });
      final result = await command.run();
      expect(result, equals(ExitCode.success.code));
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
            'project_name': 'my_app',
            'org_name': 'com.example',
            'description': 'some description',
            'android': true,
            'ios': true,
            'web': true,
            'linux': true,
            'macos': true,
            'windows': true,
          },
          logger: logger,
        ),
      ).called(1);
    });

    group('org-name', () {
      group('--org', () {
        test(
          'is a valid alias',
          withRunner(
            (commandRunner, logger, printLogs) async {
              const orgName = 'com.my.org';
              final tempDir = Directory.systemTemp.createTempSync();
              final result = await commandRunner.run(
                ['create', p.join(tempDir.path, 'example'), '--org', orgName],
              );
              expect(result, equals(ExitCode.success.code));
              tempDir.deleteSync(recursive: true);
            },
          ),
          timeout: const Timeout(Duration(seconds: 60)),
        );
      });

      group('invalid --org-name', () {
        String expectedErrorMessage(String orgName) =>
            '"$orgName" is not a valid org name.\n\n'
            'A valid org name has at least 2 parts separated by "."\n'
            'Each part must start with a letter and only include '
            'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
            'and hyphens (-)\n'
            '(ex. com.example)';

        test(
          'no delimiters',
          withRunner((commandRunner, logger, printLogs) async {
            const orgName = 'My App';
            final result = await commandRunner.run(
              ['create', '.', '--org-name', orgName],
            );
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'less than 2 domains',
          withRunner((commandRunner, logger, printLogs) async {
            const orgName = 'badorgname';
            final result = await commandRunner.run(
              ['create', '.', '--org-name', orgName],
            );
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'invalid characters present',
          withRunner((commandRunner, logger, printLogs) async {
            const orgName = 'bad%.org@.#name';
            final result = await commandRunner.run(
              ['create', '.', '--org-name', orgName],
            );
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'segment starts with a non-letter',
          withRunner((commandRunner, logger, printLogs) async {
            const orgName = 'bad.org.1name';
            final result = await commandRunner.run(
              ['create', '.', '--org-name', orgName],
            );
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );

        test(
          'valid prefix but invalid suffix',
          withRunner((commandRunner, logger, printLogs) async {
            const orgName = 'some.good.prefix.bad@@suffix';
            final result = await commandRunner.run(
              ['create', '.', '--org-name', orgName],
            );
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage(orgName))).called(1);
          }),
        );
      });

      group('valid --org-name', () {
        Future<void> expectValidOrgName(String orgName) async {
          final argResults = MockArgResults();
          final generator = MockMasonGenerator();
          final command = CreateCommand(
            logger: logger,
            generator: (_) async => generator,
          )..argResultOverrides = argResults;
          when(
            () => argResults['project-name'] as String?,
          ).thenReturn('my_app');
          when(() => argResults['org-name'] as String?).thenReturn(orgName);
          when(() => argResults.rest).thenReturn(['.tmp']);
          when(() => generator.id).thenReturn('generator_id');
          when(() => generator.description).thenReturn('generator description');
          when(
            () => generator.generate(
              any(),
              vars: any(named: 'vars'),
              logger: any(named: 'logger'),
            ),
          ).thenAnswer((_) async {
            File(p.join('.tmp', 'pubspec.yaml')).writeAsStringSync(pubspec);
            return generatedFiles;
          });
          final result = await command.run();
          expect(result, equals(ExitCode.success.code));
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
                'project_name': 'my_app',
                'description': '',
                'org_name': orgName,
                'android': true,
                'ios': true,
                'web': true,
                'linux': true,
                'macos': true,
                'windows': true,
              },
              logger: logger,
            ),
          ).called(1);
        }

        test('alphanumeric with three parts', () async {
          await expectValidOrgName('com.example.app');
        });

        test('containing an underscore', () async {
          await expectValidOrgName('com.example.bad_app');
        });

        test('containing a hyphen', () async {
          await expectValidOrgName('com.example.bad-app');
        });

        test('single character parts', () async {
          await expectValidOrgName('c.e.a');
        });

        test('more than three parts', () async {
          await expectValidOrgName('com.example.app.identifier');
        });

        test('less than three parts', () async {
          await expectValidOrgName('com.example');
        });
      });
    });
  });
}
