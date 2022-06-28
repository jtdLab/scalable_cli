part of '../commands.dart';

/// {@template generate_localization_command}
/// `scalable generate localization` command (re-)generates the localizations of this project.
/// {@endtemplate}
class LocalizationCommand extends TargetCommand {
  /// {@macro generate_localization_command}
  LocalizationCommand({
    Logger? logger,
    PubspecFile? pubspec,
    FlutterGenL10nCommand? flutterGenl10n,
  })  : pubspec = pubspec ?? Project.pubspec,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        super(
          logger: logger ?? Logger(),
          target: Target.localization,
        );

  @override
  final PubspecFile pubspec;
  final FlutterGenL10nCommand _flutterGenl10n;

  @override
  String get description => '(Re-)Generates the localizations of this project.';

  @override
  Future<int> run() => runWhenPubspecExists(() async {
        final runProgress = logger.progress(
          'Generating ${lightYellow.wrap('localization')}',
        );
        _flutterGenl10n();
        runProgress.complete('Generated ${lightYellow.wrap('localization')}');

        return ExitCode.success.code;
      });
}
