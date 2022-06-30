import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:scalable_cli/src/commands/core/generator_builder.dart';
import 'package:scalable_cli/src/commands/core/is_enabled_in_project.dart';
import 'package:scalable_cli/src/commands/core/logging.dart';
import 'package:scalable_cli/src/commands/core/platform_flags.dart';
import 'package:scalable_cli/src/commands/core/pubspec_required.dart';
import 'package:scalable_cli/src/commands/core/testable_arg_results.dart';
import 'package:scalable_cli/src/commands/new/commands/bloc/bloc_bundle.dart';
import 'package:scalable_cli/src/commands/new/commands/cubit/cubit_bundle.dart';
import 'package:scalable_cli/src/commands/new/commands/dto/dto_bundle.dart';
import 'package:scalable_cli/src/commands/new/commands/entity/entity_bundle.dart';
import 'package:scalable_cli/src/commands/new/commands/flow/flow_bundle.dart';
import 'package:scalable_cli/src/commands/new/commands/page/page_bundle.dart';
import 'package:scalable_cli/src/commands/new/commands/service/service_bundle.dart';
import 'package:scalable_cli/src/commands/new/commands/value_object/value_object_bundle.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:scalable_cli/src/core/project.dart';
import 'package:scalable_cli/src/core/pubspec_file.dart';
import 'package:scalable_cli/src/core/root_dir.dart';

part 'bloc/bloc.dart';
part 'core/output_dir_option.dart';
part 'core/platform_generator.dart';
part 'core/single_generator.dart';
part 'cubit/cubit.dart';
part 'dto/dto.dart';
part 'entity/entity.dart';
part 'flow/flow.dart';
part 'page/page.dart';
part 'service/service.dart';
part 'value_object/value_object.dart';

enum Component {
  bloc,
  cubit,
  dto,
  entity,
  flow,
  page,
  service,
  valueObject;

  String get prettyName {
    switch (this) {
      case Component.bloc:
        return 'bloc';
      case Component.cubit:
        return 'cubit';
      case Component.dto:
        return 'data transfer object';
      case Component.entity:
        return 'entity';
      case Component.flow:
        return 'flow';
      case Component.page:
        return 'page';
      case Component.service:
        return 'service';
      case Component.valueObject:
        return 'value object';
    }
  }
}

/// The default name of a component that is used if the user did not specify a name.
const _defaultName = 'My';

/// {@template component_command}
/// Base class for all new sub commands.
/// {@endtemplate}
abstract class ComponentCommand extends Command<int>
    with Logging, TestableArgResults, PubspecRequired {
  // TODO output dir getters should be part of this class componentcommand and not mixin
  /// {@macro component_command}
  ComponentCommand({
    required this.logger,
    required RootDir root,
    required this.pubspec,
    required Component component,
    required MasonBundle bundle,
    required GeneratorBuilder generator,
  })  : _root = root,
        _component = component,
        _bundle = bundle,
        _generator = generator;

  @override
  final Logger logger;
  final RootDir _root;
  @override
  final PubspecFile pubspec;
  final Component _component;
  final MasonBundle _bundle;
  final GeneratorBuilder _generator;

  @override
  String get description =>
      'Adds new ${_component.prettyName} + tests to this project.';

  @override
  String get summary => '$invocation\n$description';

  @override
  String get name => _component.name;

  @override
  String get invocation => 'scalable new $name';

  /// Gets the project name
  String get _projectName => pubspec.name;

  /// Gets the output dir.
  String get _outputDir =>
      argResults['output-dir'] ??
      ''; // TODO correct location ? or to ouput dir gettrs mixin

  /// Gets the name of the component specified by the user.
  ///
  /// Returns [_defaultName] when no name specified.
  String get _name {
    try {
      return argResults.arguments.first.pascalCase;
    } catch (_) {
      return _defaultName;
    }
  }
}
