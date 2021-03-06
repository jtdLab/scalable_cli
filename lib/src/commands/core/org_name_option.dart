import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:scalable_cli/src/commands/core/overridable_arg_results.dart';

/// The default organization name.
const _defaultOrgName = 'com.example';

/// The regex for the organization name.
final _orgNameRegExp = RegExp(r'^[a-zA-Z][\w-]*(\.[a-zA-Z][\w-]*)+$');

/// Exception that occurs when org-name is invalid.
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

/// Adds organization name option.
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

/// Adds `orgName` getter.
mixin OrgNameGetters on OverridableArgResults {
  /// Gets the organization name specified by the user.
  ///
  /// Returns [_defaultOrgName] when no organization name specified.
  String get orgName =>
      _validateOrgName(argResults['org-name'] ?? _defaultOrgName);

  /// Validates whether [name] is valid organization name.
  ///
  /// Returns [name] when valid.
  String _validateOrgName(String name) {
    final isValid = _isValidOrgName(name);
    if (!isValid) {
      throw InvalidOrgName(name, usage);
    }
    return name;
  }

  /// Whether [name] is valid organization name.
  bool _isValidOrgName(String name) => _orgNameRegExp.hasMatch(name);
}
