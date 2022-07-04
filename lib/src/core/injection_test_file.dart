import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project_file.dart';

/// {@template injection_test_file}
/// Abstraction of the `test/core/injection_test.dart` file in a Scalable project.
/// {@endtemplate}
class InjectionTestFile extends ProjectFile {
  /// {@macro injection_test_file}
  InjectionTestFile() : super('test/core/injectable_test.dart');

  /// Adds a test case which tests wheter the router of [platform] is registerd inside getIt.
  void addRouterTest(Platform platform) {
    // TODO implement
    throw UnimplementedError();
  }
}
