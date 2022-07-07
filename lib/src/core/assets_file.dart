import 'package:scalable_cli/src/core/project_file.dart';

/// {@template assets_file}
/// Abstraction of the `lib/core/assets.dart` file in a Scalable project.
/// {@endtemplate}
class AssetsFile extends ProjectFile {
  /// {@macro assets_file}
  AssetsFile() : super('lib/core/assets.dart');

  /// (Re-)generates this file depending on provided assets.
  void generate() {
    // TODO implement
    throw UnimplementedError();
  }
}
