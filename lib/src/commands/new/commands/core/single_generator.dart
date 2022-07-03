part of '../commands.dart';

/// Adds functionality that generates a component into a single location.
///
/// Relevant components are bloc, cubit, dto, entity, service and valueObject.
mixin SingleGenerator on NewSubCommand {
  @override
  Future<int> run() => runWhenPubspecExists(() async {
        final generateProgress = logger.progress(
          'Generating ${lightYellow.wrap('$_name${_component.name.pascalCase}')}',
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
          'Generated ${lightYellow.wrap('$_name${_component.name.pascalCase}')}',
        );

        // TODO keep or remove
        // logger.info('');

        // for (final file in files) {
        //   logger.success(p.relative(file.path, from: _root.path));
        // }
        // logger.info('');

        return ExitCode.success.code;
      });

  /// Gets the vars of the [bundle].
  Map<String, dynamic> get vars;
}
