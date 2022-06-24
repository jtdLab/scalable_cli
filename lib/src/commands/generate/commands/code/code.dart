part of '../commands.dart';

/// {@template generate_code_command}
/// `scalable generate code` command (re-)generates the code of this project.
/// {@endtemplate}
class CodeCommand extends TargetCommand {
  /// {@macro generate_code_command}
  CodeCommand({
    Logger? logger,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    InjectionConfigFile? injectionConfig,
    Set<RouterGrFile>? routerGrs,
  })  : _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _injectionConfig = injectionConfig ?? Project.injectionConfig,
        _routerGrs = routerGrs ?? Project.routerGrs,
        super(
          logger: logger ?? Logger(),
          target: Target.code,
        );

  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final InjectionConfigFile _injectionConfig;
  final Set<RouterGrFile> _routerGrs;

  @override
  String get description => '(Re-)Generates the code of this project.';

  @override
  Future<int> run() => cwdContainsPubspec(
        onContainsPubspec: () async {
          final runProgress =
              logger.progress('Generating ${lightYellow.wrap('code')}');
          await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs();

          _injectionConfig.addCoverageIgnoreFile();
          for (final routerGr in _routerGrs) {
            routerGr.addCoverageIgnoreFile();
          }
          runProgress.complete('Generated ${lightYellow.wrap('code')}');

          return ExitCode.success.code;
        },
      );
}
