import 'package:scalable_cli/src/core/project_dir.dart';

/// {@template presentation_dir}
/// Abstraction of the `lib/presentation` directory in a Scalable project.
/// {@endtemplate}
class PresentationDir extends ProjectDir with ContainsPlatformDir {
  /// {@macro presentation_dir}
  PresentationDir() : super('lib/presentation');
}
