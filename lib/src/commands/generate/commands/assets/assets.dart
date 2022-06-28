part of '../commands.dart';

/// {@template generate_assets_command}
/// `scalable generate assets` command (re-)generates the assets of this project.
/// {@endtemplate}
class AssetsCommand extends TargetCommand {
  /// {@macro generate_assets_command}
  AssetsCommand({
    Logger? logger,
    PubspecFile? pubspec,
    AssetsFile? assets,
  })  : pubspec = pubspec ?? Project.pubspec,
        _assets = assets ?? Project.assets,
        super(
          logger: logger ?? Logger(),
          target: Target.assets,
        );

  @override
  final PubspecFile pubspec;
  final AssetsFile _assets;

  @override
  String get description => '(Re-)Generates the assets of this project.';

  @override
  Future<int> run() => runWhenPubspecExists(() async {
        final runProgress = logger.progress('Generating assets');
        pubspec.updateFlutterAssets();
        pubspec.updateFlutterFonts();
        _assets.generate();
        runProgress.complete('Generated assets');

        return ExitCode.success.code;
      });
}
