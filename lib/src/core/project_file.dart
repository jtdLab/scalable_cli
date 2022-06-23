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

// TODO
class ProjectFile {
  final String path;

  ProjectFile(this.path);

  File get file => File(path);
}
