part of '../commands.dart';

/// The default output directory
const _defaultOutputDir = '';

/// Adds output directory option.
extension OutputDirOption on ArgParser {
  void addOutputDirOption({required String help}) {
    addOption(
      'output-dir',
      help: help,
      abbr: 'o',
      defaultsTo: _defaultOutputDir,
    );
  }
}
