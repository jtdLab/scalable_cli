import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:scalable_cli/src/commands/core/testable_arg_results.dart';

const _defaultOrgName = 'com.example';

final _orgNameRegExp = RegExp(r'^[a-zA-Z][\w-]*(\.[a-zA-Z][\w-]*)+$');

// TODO doc
class InvalidOrgName extends UsageException {
  InvalidOrgName(String name, String usage)
      : super(
          '"$name" is not a valid org name.\n\n'
          'A valid org name has at least 2 parts separated by "."\n'
          'Each part must start with a letter and only include '
          'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
          'and hyphens (-)\n'
          '(ex. com.example)',
          usage,
        );
}

// TODO doc
extension OrgNameOption on ArgParser {
  /// Adds `--org-name`, `--org` option.
  void addOrgNameOption({required String help}) {
    addOption(
      'org-name',
      help: help,
      aliases: ['org'],
      defaultsTo: _defaultOrgName,
    );
  }
}

// TODO doc
mixin OrgNameGetters on TestableArgResults {
  /// Gets the organization name.
  String get orgName =>
      _validateOrgName(argResults['org-name'] ?? _defaultOrgName);

  String _validateOrgName(String name) {
    final isValid = _isValidOrgName(name);
    if (!isValid) {
      throw InvalidOrgName(name, usage);
    }
    return name;
  }

  bool _isValidOrgName(String name) => _orgNameRegExp.hasMatch(name);
}
