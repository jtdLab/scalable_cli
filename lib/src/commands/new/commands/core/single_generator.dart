part of '../commands.dart';

// TODO name + doc
mixin SingleGenerator on ComponentCommand {
  @override
  Future<int> run() => cwdContainsPubspec(
        onContainsPubspec: () async {
          final generateProgress = logger.progress(
            'Generating ${lightYellow.wrap('$name${_component.name.pascalCase}')}',
          );
          final generator = await _generator(_bundle);
          final files = await generator.generate(
            DirectoryGeneratorTarget(_root.directory),
            vars: {
              'project_name': _projectName,
              'name': _name,
              ...vars,
            },
            logger: logger,
          );
          generateProgress.complete(
            'Generated ${lightYellow.wrap('$name${_component.name.pascalCase}')}',
          );
          logger.info('');

          for (final file in files) {
            logger.success(p.relative(file.path, from: _root.path));
          }
          logger.info('');

          return ExitCode.success.code;
        },
      );

  /// Gets the vars of the [bundle].
  Map<String, dynamic> get vars;
}
