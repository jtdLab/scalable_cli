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
  })  : _pubspec = pubspec ?? Project.pubspec,
        _assets = assets ?? Project.assets,
        super(
          logger: logger ?? Logger(),
          target: Target.assets,
        );

  final PubspecFile _pubspec;
  final AssetsFile _assets;

  @override
  String get description => '(Re-)Generates the assets of this project.';

  @override
  Future<int> run() => cwdContainsPubspec(
        onContainsPubspec: () async {
          // TODO cwd pubspec and _pubspec must not be pointing to the same file thats a problem
          final runProgress = logger.progress('Generating assets');
          _pubspec.updateFlutterAssets();
          _pubspec.updateFlutterFonts();
          _assets.generate();
          runProgress.complete('Generated assets');

          return ExitCode.success.code;
        },
      );
}
