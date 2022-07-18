import 'package:dart_style/dart_style.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project.dart';
import 'package:scalable_cli/src/core/project_file.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';

// TODO impl is tested and works but doc and file should be cleaned up

// TODO impl
class InvalidMainFile implements Exception {}

// TODO impl
class PlatformAlreadyRegistered implements Exception {}

/// The flavour that belongs to a [MainFile].
enum Flavour {
  development,
  test,
  production;

  /// Returns a string representation of the freezed annotation this belongs to.
  String toAnnotationString() {
    switch (this) {
      case Flavour.development:
        return 'dev';
      case Flavour.test:
        return 'test';
      case Flavour.production:
        return 'prod';
    }
  }
}

/// {@template main_file}
/// Abstraction of `lib/main_<flavour>.dart` file in a Scalable project.
/// {@endtemplate}
class MainFile extends ProjectFile {
  //final String projectName;
  final Flavour flavour;

  final PubspecFile _pubspec;

  /// {@macro main_file}
  MainFile(
    this.flavour, {
    PubspecFile? pubspec,
  })  : _pubspec = pubspec ?? Project.pubspec,
        super('lib/main_${flavour.name}.dart');

  /// Adds [platform] to this.
  void addPlatform(Platform platform) {
    // 1. Remove new lines
    final data = file.readAsStringSync();

    if ('return PlatformWidget'.allMatches(data).length != 1) {
      // data must contain exactly 1 return PlatformWidget statment
      throw InvalidMainFile();
    }

    // 2. Find "return PlatformWidget"
    final splitted = data.split('return PlatformWidget');
    var pre = splitted.first;

    // ?.
    final imports = pre
        .split('\n')
        .where((element) => element.startsWith('import'))
        .toList();
    // TODO platform name is hard coded to example
    imports.add(
      'import \'package:${_pubspec.name}/presentation/${platform.name}/app.dart\' as ${platform.name};',
    );
    imports.sort();
    pre = pre.replaceAll(RegExp('import \'.*;\n'), '');
    pre = '${imports.join('\n')}\n$pre';

    var post = splitted.last;

    // 3. Find OPENING as the first "(" after 2.
    final openingBraceIndex = post.indexOf('(');
    // 4. Count number of "(" before 2.
    final numberOfOpeningBracesInPre = '('.allMatches(pre).length;
    // 5. Count number of ")" before 2.
    final numberOfClosingBracesInPre = ')'.allMatches(pre).length;
    // 6. Start from end and find index of ")" after ignoring (4-5) ")"s. Call it CLOSING
    final allClosingBracesInPost =
        ')'.allMatches(post).toList().reversed.toList();
    final closingBraceIndex = allClosingBracesInPost[
            numberOfOpeningBracesInPre - numberOfClosingBracesInPre]
        .start;
    // 7. The chars between 3. and 6. are called PLATFORMS
    final platforms = post.substring(openingBraceIndex + 1, closingBraceIndex);

    if (platforms.contains('${platform.name}:')) {
      // already registered
      return;
    }

    // 8. Add new section of the enabled platform to the end of PLATFORMS
    // TODO format
    final newPlatform = '''
 ${platform.name}: (context) {
   configureDependencies(Environment.${flavour.toAnnotationString()}, Platform.${platform.name});
   return const ${platform.name}.App();
 },
 ''';
    post = post.substring(0, openingBraceIndex + 1) +
        platforms +
        newPlatform +
        post.substring(closingBraceIndex);

    // Write to disc
    final newContent = '${pre}return PlatformWidget$post';
    final formatter = DartFormatter();
    file.writeAsStringSync(formatter.format(newContent));
  }
}
