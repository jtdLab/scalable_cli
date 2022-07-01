// TODO
import 'package:universal_io/io.dart';

mixin AddCoverageIgnoreFile on ProjectFile {
  void addCoverageIgnoreFile() {
    final lines = file.readAsLinesSync();

    final newLines = [
      '// coverage:ignore-file'
          '',
      ...lines
    ];

    file.writeAsStringSync(
      newLines.join('/n'),
      mode: FileMode.write,
      flush: true,
    );
  }
}

/// {@template project_file}
/// Base class for a file in a Scalable project.
/// {@endtemplate}
class ProjectFile {
  /// {@macro project_file}
  ProjectFile(this.path);

  /// The path of this.
  final String path;

  /// Gets the underlying file of this.
  File get file => File(path);
}
