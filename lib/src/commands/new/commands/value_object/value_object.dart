part of '../commands.dart';

/// The default type.
const _defaultType = 'MyType';

/// {@template new_value_object_command}
/// `scalable create` command creates a new value object + test.
/// {@endtemplate}
class ValueObjectCommand extends NewSubCommand with SingleGenerator {
  /// {@macro new_value_object_command}
  ValueObjectCommand({
    Logger? logger,
    RootDir? root,
    PubspecFile? pubspec,
    GeneratorBuilder? generator,
  }) : super(
          logger: logger ?? Logger(),
          root: root ?? Project.rootDir,
          pubspec: pubspec ?? Project.pubspec,
          component: Component.valueObject,
          bundle: valueObjectBundle,
          generator: generator ?? MasonGenerator.fromBundle,
        ) {
    argParser
      ..addOutputDirOption(help: 'The output directory inside lib/domain/.')
      ..addSeparator('')
      ..addOption(
        'type',
        help: 'The type that gets wrapped by this value object.\n'
            'Generics get escaped via "#" e.g Tuple<#A, #B, String>.',
        defaultsTo: _defaultType,
      );
  }

  @override
  List<String> get aliases => ['vo'];

  @override
  Map<String, dynamic> get vars => {
        'path': _path,
        'type': _type,
        'generics': _generics,
      };

  String get _path => p.join('domain', _outputDir);

  String get _type => argResults['type']?.replaceAll('#', '') ?? _defaultType;

  String get _generics {
    final raw = argResults['type'] as String? ?? _defaultType;
    StringBuffer buffer = StringBuffer();
    buffer.write('<');

    final generics = raw
        .replaceAll(' ', '')
        .split(RegExp('[,<>]'))
        .where((element) => element.startsWith('#'))
        .map((element) => element.replaceAll('#', ''))
        .toList();

    for (int i = 0; i < generics.length; i++) {
      buffer.write(generics[i]);
      if (i != generics.length - 1) {
        buffer.write(', ');
      }
    }

    buffer.write('>');

    final string = buffer.toString();

    if (string == '<>') {
      return '';
    }

    return buffer.toString();
  }
}
