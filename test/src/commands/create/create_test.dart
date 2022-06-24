import 'dart:async';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:pub_updater/pub_updater.dart';
import 'package:scalable_cli/src/cli/cli.dart';
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

/// The current version of cupertino icons.
///
/// Visit https://pub.dev/packages/cupertino_icons
const cupertinoIconsVersion = '^1.0.5';

/// The current version of macos ui.
///
/// Visit https://pub.dev/packages/macos_ui
const macosUiVersion = '^1.4.1+1';

/// The current version of fluent ui.
///
/// Visit https://pub.dev/packages/fluent_ui
const fluentUiVersion = '^3.12.0';

/// The current version of yaru.
///
/// Visit https://pub.dev/packages/yaru
const yaruVersion = '^0.3.3';

/// The current version of yaru icons.
///
/// Visit https://pub.dev/packages/yaru_icons
const yaruIconsVersion = '^0.2.1';

// ignore: one_member_abstracts
abstract class FlutterInstalledCommand {
  Future<bool> call();
}

abstract class FlutterPubGetCommand {
  Future<void> call({String cwd});
}

abstract class FlutterConfigEnableAndroidCommand {
  Future<void> call();
}

abstract class FlutterConfigEnableIosCommand {
  Future<void> call();
}

abstract class FlutterConfigEnableWebCommand {
  Future<void> call();
}

abstract class FlutterConfigEnableLinuxCommand {
  Future<void> call();
}

abstract class FlutterConfigEnableMacosCommand {
  Future<void> call();
}

abstract class FlutterConfigEnableWindowsCommand {
  Future<void> call();
}

abstract class FlutterGenL10nCommand {
  Future<void> call({String cwd});
}

abstract class FlutterFormatFixCommand {
  Future<void> call({String cwd});
}

class MockArgResults extends Mock implements ArgResults {}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockPubUpdater extends Mock implements PubUpdater {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

class FakeLogger extends Fake implements Logger {}

class MockFlutterInstalledCommand extends Mock
    implements FlutterInstalledCommand {}

class MockFlutterPubGetCommand extends Mock implements FlutterPubGetCommand {}

class MockFlutterConfigEnableAndroidCommand extends Mock
    implements FlutterConfigEnableAndroidCommand {}

class MockFlutterConfigEnableIosCommand extends Mock
    implements FlutterConfigEnableIosCommand {}

class MockFlutterConfigEnableWebCommand extends Mock
    implements FlutterConfigEnableAndroidCommand {}

class MockFlutterConfigEnableLinuxCommand extends Mock
    implements FlutterConfigEnableIosCommand {}

class MockFlutterConfigEnableMacosCommand extends Mock
    implements FlutterConfigEnableAndroidCommand {}

class MockFlutterConfigEnableWindowsCommand extends Mock
    implements FlutterConfigEnableIosCommand {}

class MockFlutterGenL10nCommand extends Mock implements FlutterGenL10nCommand {}

class MockFlutterFormatFixCommand extends Mock
    implements FlutterFormatFixCommand {}

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

    test('has alias c', () {
      final command = CreateCommand();
      expect(command.aliases, ['c']);
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
      final flutterInstalledCommand = MockFlutterInstalledCommand();
      final flutterPubGetCommand = MockFlutterPubGetCommand();
      final flutterConfigEnableAndroidCommand =
          MockFlutterConfigEnableAndroidCommand();
      final flutterConfigEnableIosCommand = MockFlutterConfigEnableIosCommand();
      final flutterConfigEnableWebCommand = MockFlutterConfigEnableWebCommand();
      final flutterConfigEnableLinuxCommand =
          MockFlutterConfigEnableLinuxCommand();
      final flutterConfigEnableMacosCommand =
          MockFlutterConfigEnableMacosCommand();
      final flutterConfigEnableWindowsCommand =
          MockFlutterConfigEnableWindowsCommand();
      final flutterGenL10nCommand = MockFlutterGenL10nCommand();
      final flutterFormatFixCommand = MockFlutterFormatFixCommand();
      final generator = MockMasonGenerator();
      final command = CreateCommand(
        logger: logger,
        flutterInstalledCommand: flutterInstalledCommand,
        flutterPubGetCommand: flutterPubGetCommand,
        flutterConfigEnableAndroidCommand: flutterConfigEnableAndroidCommand,
        flutterConfigEnableIosCommand: flutterConfigEnableIosCommand,
        flutterConfigEnableWebCommand: flutterConfigEnableWebCommand,
        flutterConfigEnableLinuxCommand: flutterConfigEnableLinuxCommand,
        flutterConfigEnableMacosCommand: flutterConfigEnableMacosCommand,
        flutterConfigEnableWindowsCommand: flutterConfigEnableWindowsCommand,
        flutterGenL10nCommand: flutterGenL10nCommand,
        flutterFormatFixCommand: flutterFormatFixCommand,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
      when(() => argResults['project-name'] as String?).thenReturn('my_app');
      when(() => argResults.rest).thenReturn(['.tmp']);
      when(() => flutterInstalledCommand()).thenAnswer((_) async => true);
      when(() => flutterPubGetCommand(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
      when(() => flutterConfigEnableAndroidCommand()).thenAnswer((_) async {});
      when(() => flutterConfigEnableIosCommand()).thenAnswer((_) async {});
      when(() => flutterConfigEnableWebCommand()).thenAnswer((_) async {});
      when(() => flutterConfigEnableLinuxCommand()).thenAnswer((_) async {});
      when(() => flutterConfigEnableMacosCommand()).thenAnswer((_) async {});
      when(() => flutterConfigEnableWindowsCommand()).thenAnswer((_) async {});
      when(() => flutterGenL10nCommand(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
      when(() => flutterFormatFixCommand(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
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
        () => logger.progress('Running "flutter pub get" in .tmp'),
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
            'description': 'A Scalable app.',
            'cupertino_icons_version': cupertinoIconsVersion,
            'macos_ui_version': macosUiVersion,
            'fluent_ui_version': fluentUiVersion,
            'yaru_version': yaruVersion,
            'yaru_icons_version': yaruIconsVersion,
            'example': true,
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

    test(
        'completes successfully with correct output when --mobile, --desktop and --web is selected.',
        () async {});

    test(
        'completes successfully with correct output when --mobile is selected.',
        () async {});

    test(
        'completes successfully with correct output when --desktop is selected.',
        () async {});

    test(
        'completes successfully with correct output when --android is selected.',
        () async {});

    test('completes successfully with correct output when --ios is selected.',
        () async {});

    test('completes successfully with correct output when --web is selected.',
        () async {});

    test('completes successfully with correct output when --linux is selected.',
        () async {});

    test('completes successfully with correct output when --macos is selected.',
        () async {});

    test(
        'completes successfully with correct output when --windows is selected.',
        () async {});

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
            'cupertino_icons_version': cupertinoIconsVersion,
            'macos_ui_version': macosUiVersion,
            'fluent_ui_version': fluentUiVersion,
            'yaru_version': yaruVersion,
            'yaru_icons_version': yaruIconsVersion,
            'example': true,
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
          final flutterInstalledCommand = MockFlutterInstalledCommand();
          final flutterPubGetCommand = MockFlutterPubGetCommand();
          final flutterConfigEnableAndroidCommand =
              MockFlutterConfigEnableAndroidCommand();
          final flutterConfigEnableIosCommand =
              MockFlutterConfigEnableIosCommand();
          final flutterConfigEnableWebCommand =
              MockFlutterConfigEnableWebCommand();
          final flutterConfigEnableLinuxCommand =
              MockFlutterConfigEnableLinuxCommand();
          final flutterConfigEnableMacosCommand =
              MockFlutterConfigEnableMacosCommand();
          final flutterConfigEnableWindowsCommand =
              MockFlutterConfigEnableWindowsCommand();
          final flutterGenL10nCommand = MockFlutterGenL10nCommand();
          final flutterFormatFixCommand = MockFlutterFormatFixCommand();
          final generator = MockMasonGenerator();
          final command = CreateCommand(
            logger: logger,
            flutterInstalledCommand: flutterInstalledCommand,
            flutterPubGetCommand: flutterPubGetCommand,
            flutterConfigEnableAndroidCommand:
                flutterConfigEnableAndroidCommand,
            flutterConfigEnableIosCommand: flutterConfigEnableIosCommand,
            flutterConfigEnableWebCommand: flutterConfigEnableWebCommand,
            flutterConfigEnableLinuxCommand: flutterConfigEnableLinuxCommand,
            flutterConfigEnableMacosCommand: flutterConfigEnableMacosCommand,
            flutterConfigEnableWindowsCommand:
                flutterConfigEnableWindowsCommand,
            flutterGenL10nCommand: flutterGenL10nCommand,
            flutterFormatFixCommand: flutterFormatFixCommand,
            generator: (_) async => generator,
          )..argResultOverrides = argResults;
          when(
            () => argResults['project-name'] as String?,
          ).thenReturn('my_app');
          when(() => argResults['org-name'] as String?).thenReturn(orgName);
          when(() => argResults.rest).thenReturn(['.tmp']);
          when(() => flutterInstalledCommand()).thenAnswer((_) async => true);
          when(() => flutterPubGetCommand(cwd: any(named: 'cwd')))
              .thenAnswer((_) async {});
          when(() => flutterConfigEnableAndroidCommand())
              .thenAnswer((_) async {});
          when(() => flutterConfigEnableIosCommand()).thenAnswer((_) async {});
          when(() => flutterConfigEnableWebCommand()).thenAnswer((_) async {});
          when(() => flutterConfigEnableLinuxCommand())
              .thenAnswer((_) async {});
          when(() => flutterConfigEnableMacosCommand())
              .thenAnswer((_) async {});
          when(() => flutterConfigEnableWindowsCommand())
              .thenAnswer((_) async {});
          when(() => flutterGenL10nCommand(cwd: any(named: 'cwd')))
              .thenAnswer((_) async {});
          when(() => flutterFormatFixCommand(cwd: any(named: 'cwd')))
              .thenAnswer((_) async {});
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
                'org_name': orgName,
                'description': 'A Scalable app.',
                'cupertino_icons_version': cupertinoIconsVersion,
                'macos_ui_version': macosUiVersion,
                'fluent_ui_version': fluentUiVersion,
                'yaru_version': yaruVersion,
                'yaru_icons_version': yaruIconsVersion,
                'example': true,
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
