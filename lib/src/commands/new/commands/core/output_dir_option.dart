part of '../commands.dart';

extension OutputDirOption on ArgParser {
  void addOutputDirOption({required String help}) {
    addOption(
      'output-dir',
      help: help,
      abbr: 'o',
      defaultsTo: '', // TODO ??
    );
  }
}
