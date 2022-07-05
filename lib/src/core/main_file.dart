import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project_file.dart';

// TODO impl
class MustContainOnePlatformWidget implements Exception {}

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
  final Flavour flavour;

  /// {@macro main_file}
  MainFile(this.flavour) : super('lib/main_${flavour.name}.dart');

  /// Adds [platform] to this.
  void addPlatform(Platform platform) {
    // 1. Remove new lines
    final data = file.readAsStringSync();

    if ('return PlatformWidget'.allMatches(data).length != 1) {
      // data must contain exactly 1 return PlatformWidget statment
      throw MustContainOnePlatformWidget();
    }

    // 2. Find "return PlatformWidget"
    final splitted = data.split('return PlatformWidget');
    final pre = splitted.first;
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
      throw PlatformAlreadyRegistered();
    }

    // TODO platform name is hard coded to kek
    // Add app import
    final import =
        'import \'package:kek/presentation/${platform.name}/app.dart\' as ${platform.name};\n';

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
    file.writeAsStringSync('$import${pre}return PlatformWidget$post');
  }
}

