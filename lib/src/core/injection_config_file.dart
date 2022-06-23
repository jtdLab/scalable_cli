import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project_file.dart';

/// {@template injection_config_file}
/// Abstraction of the `lib/core/injection.config.dart` file in a Scalable project.
/// {@endtemplate}
class InjectionConfigFile extends ProjectFile with AddCoverageIgnoreFile {
  /// {@macro injection_config_file}
  InjectionConfigFile() : super('lib/core/injection.config.dart');

  // TODO: doc
  void addRouter(Platform platform) {
    // TODO: impl cleaner
    // 1. Find next alias call it ALIAS

    final lines = file.readAsLinesSync();
    final imports = lines.where((line) => line.startsWith('import'));

    final aliases = imports.map(
      (e) => e.split('as').last.trim().replaceAll(';', ''),
    );
    final numbers = aliases
        .map((e) => e.replaceAll('_i', ''))
        .map((e) => int.parse(e))
        .toList();
    numbers.sort();
    final nextNumber = numbers.last + 1;

    // 2. add import to platform router file as ALIAS
    lines.insert(
      lines.lastIndexWhere((e) => e.startsWith('import')) + 1,
      'import \'../presentation/${platform.name}/core/router.dart\' as _i$nextNumber;',
    );

    // 3. find return get;
    // 4. add "  gh.lazySingleton<ALIAS.Router>(() => ALIAS.Router());" beofre 3.
    lines.insert(
      lines.lastIndexWhere((e) => e.trim().startsWith('return get')),
      '  gh.lazySingleton<_i$nextNumber.Router>(() => _i$nextNumber.Router());',
    );

    file.writeAsStringSync(lines.join('\n'));
  }

  // TODO: doc
  void replaceGetItAndInjectableImportsWithScalabeCore() {
    // Removes implicit imports to getIt and Injectable
    // Then take one of their aliases and import scalable core as it.

    // TODO impl for linting purposes in resulting project
    throw UnimplementedError();
  }
}
