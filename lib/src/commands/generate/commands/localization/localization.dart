part of '../commands.dart';

/// {@template generate_localization_command}
/// `scalable generate localization` command (re-)generates the localizations of this project.
/// {@endtemplate}
class LocalizationCommand extends TargetCommand {
  /// {@macro generate_localization_command}
  LocalizationCommand({
    Logger? logger,
    FlutterGenL10nCommand? flutterGenl10n,
  })  : _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        super(
          logger: logger ?? Logger(),
          target: Target.localization,
        );

  final FlutterGenL10nCommand _flutterGenl10n;

  @override
  String get description => '(Re-)Generates the localizations of this project.';

  @override
  Future<int> run() => cwdContainsPubspec(
        onContainsPubspec: () async {
          final runProgress = logger.progress(
            'Generating ${lightYellow.wrap('localization')}',
          );
          _flutterGenl10n();
          runProgress.complete('Generated ${lightYellow.wrap('localization')}');

          return ExitCode.success.code;
        },
      );
}
