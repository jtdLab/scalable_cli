import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project_file.dart';

// TODO impl works but file needs better doc and cleanup

/// {@template injection_config_file}
/// Abstraction of the `lib/core/injection.config.dart` file in a Scalable project.
/// {@endtemplate}
class InjectionConfigFile extends ProjectFile with AddCoverageIgnoreFile {
  /// {@macro injection_config_file}
  InjectionConfigFile() : super('lib/core/injection.config.dart');

  /// Adds the router of [platform] to this.
  void addRouter(Platform platform) {
    // 1. Find next alias call it NEXT_ALIAS
    final lines = file.readAsLinesSync();

    final importAvailable = lines.any(
      (line) => RegExp(
        'import \'../presentation/${platform.name}/core/router.dart\' as _i[1-9]*;',
      ).hasMatch(line),
    );
    final constantAvailable = lines.any(
      (line) => RegExp(
        'const String _${platform.name} = \'${platform.name}\';',
      ).hasMatch(line),
    );
    final registerAvailable = lines.any(
      (line) => RegExp(
        r'  gh\.lazySingleton<_i[1-9]+\.Router>\(\(\) => _i[1-9]+\.Router\(\), registerFor: {_' +
            platform.name +
            r'}\);',
      ).hasMatch(line),
    );

    if (importAvailable && constantAvailable && registerAvailable) {
      // router of platform already added
      return;
    }

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

    // 2. add import to platform router file as NEXT_ALIAS
    lines.insert(
      lines.lastIndexWhere((e) => e.startsWith('import')) + 1,
      'import \'../presentation/${platform.name}/core/router.dart\' as _i$nextNumber;',
    );

    // Add constants
    lines.insert(
      lines.lastIndexWhere((e) => e.startsWith('const')) + 1,
      'const String _${platform.name} = \'${platform.name}\';',
    );

    // 3. find return get;
    // 4. add "  gh.lazySingleton<ALIAS.Router>(() => ALIAS.Router());" before 3.
    lines.insert(
      lines.lastIndexWhere((e) => e.trim().startsWith('return get')),
      '  gh.lazySingleton<_i$nextNumber.Router>(() => _i$nextNumber.Router(), registerFor: {_${platform.name}});',
    );

    file.writeAsStringSync('${lines.join('\n')}\n');
  }

  /// Replaces imports of getIt and injectable with scalable specific import.
  void replaceGetItAndInjectableImportsWithScalabeCore() {
    // Removes implicit imports to getIt and Injectable
    // Then take one of their aliases and import scalable core as it.

    // This method might not be needed in future when some depenendencies move out of scalable package into resulting project

    // TODO impl for linting purposes in resulting project
    throw UnimplementedError();
  }
}
