part of '../commands.dart';

// TODO doc
const _defaultOutputDir = '';

// TODO doc
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
