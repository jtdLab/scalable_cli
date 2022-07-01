import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project_file.dart';

/// {@template router_gr_file}
/// Abstraction of the `lib/presentation/<platform>/core/router.gr.dart` file in a Scalable project.
/// {@endtemplate}
class RouterGrFile extends ProjectFile with AddCoverageIgnoreFile {
  final Platform platform;

  /// {@macro router_gr_file}
  RouterGrFile(this.platform)
      : super('lib/presentation/${platform.name}/core/router.gr.dart');
}
