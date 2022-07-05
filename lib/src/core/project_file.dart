import 'package:universal_io/io.dart';

/// Provides [addCoverageIgnoreFile] method.
mixin AddCoverageIgnoreFile on ProjectFile {
  /// Adds coverage ignore file header to the start of this file.
  void addCoverageIgnoreFile() {
    final lines = file.readAsLinesSync();

    final newLines = [
      '// coverage:ignore-file',
      '',
      ...lines,
    ];

    file.writeAsStringSync(
      newLines.join('\n'),
      mode: FileMode.write,
      flush: true,
    );
  }
}

/// {@template project_file}
/// Base class for a file in a Scalable project.
/// {@endtemplate}
abstract class ProjectFile {
  /// {@macro project_file}
  ProjectFile(this.path);

  /// The path of this.
  final String path;

  /// Gets the underlying file of this.
  File get file => File(path);
}

/* /// {@template project_file}
/// Base class for a file in a Scalable project.
/// {@endtemplate}
abstract class ProjectFile2 implements File {
  /// The underlying file.
  final File _file;

  /// {@macro project_file}
  ProjectFile2(String path) : _file = File(path);

  @override
  File get absolute => _file.absolute;

  @override
  Future<File> copy(String newPath) => _file.copy(newPath);

  @override
  File copySync(String newPath) => _file.copySync(newPath);

  @override
  Future<File> create({bool recursive = false}) =>
      _file.create(recursive: recursive);

  @override
  void createSync({bool recursive = false}) =>
      _file.createSync(recursive: recursive);

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) =>
      _file.delete(recursive: recursive);

  @override
  void deleteSync({bool recursive = false}) =>
      _file.deleteSync(recursive: recursive);

  @override
  Future<bool> exists() => _file.exists();

  @override
  bool existsSync() => _file.existsSync();

  @override
  bool get isAbsolute => _file.isAbsolute;

  @override
  Future<DateTime> lastAccessed() => _file.lastAccessed();

  @override
  DateTime lastAccessedSync() => _file.lastAccessedSync();

  @override
  Future<DateTime> lastModified() => _file.lastModified();

  @override
  DateTime lastModifiedSync() => _file.lastModifiedSync();

  @override
  Future<int> length() => _file.length();

  @override
  int lengthSync() => _file.lengthSync();

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) =>
      _file.open(mode: mode);

  @override
  Stream<List<int>> openRead([int? start, int? end]) =>
      _file.openRead(start, end);

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) =>
      _file.openSync(mode: mode);

  @override
  IOSink openWrite(
          {FileMode mode = FileMode.write, Encoding encoding = utf8}) =>
      _file.openWrite(mode: mode, encoding: encoding);

  @override
  Directory get parent => _file.parent;

  @override
  String get path => _file.path;

  @override
  Future<Uint8List> readAsBytes() => _file.readAsBytes();

  @override
  Uint8List readAsBytesSync() => _file.readAsBytesSync();

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) =>
      _file.readAsLines(encoding: encoding);

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) =>
      _file.readAsLinesSync(encoding: encoding);

  @override
  Future<String> readAsString({Encoding encoding = utf8}) =>
      _file.readAsString(encoding: encoding);

  @override
  String readAsStringSync({Encoding encoding = utf8}) =>
      _file.readAsStringSync(encoding: encoding);

  @override
  Future<File> rename(String newPath) => _file.rename(newPath);

  @override
  File renameSync(String newPath) => _file.renameSync(newPath);

  @override
  Future<String> resolveSymbolicLinks() => _file.resolveSymbolicLinks();

  @override
  String resolveSymbolicLinksSync() => _file.resolveSymbolicLinksSync();

  @override
  Future setLastAccessed(DateTime time) => _file.setLastAccessed(time);

  @override
  void setLastAccessedSync(DateTime time) => _file.setLastAccessedSync(time);

  @override
  Future setLastModified(DateTime time) => _file.setLastModified(time);

  @override
  void setLastModifiedSync(DateTime time) => _file.setLastModifiedSync(time);

  @override
  Future<FileStat> stat() => _file.stat();

  @override
  FileStat statSync() => _file.statSync();

  @override
  Uri get uri => _file.uri;

  @override
  Stream<FileSystemEvent> watch({
    int events = FileSystemEvent.all,
    bool recursive = false,
  }) =>
      _file.watch(events: events, recursive: recursive);

  @override
  Future<File> writeAsBytes(
    List<int> bytes, {
    FileMode mode = FileMode.write,
    bool flush = false,
  }) =>
      _file.writeAsBytes(bytes, mode: mode, flush: flush);

  @override
  void writeAsBytesSync(
    List<int> bytes, {
    FileMode mode = FileMode.write,
    bool flush = false,
  }) =>
      _file.writeAsBytesSync(bytes, mode: mode, flush: flush);

  @override
  Future<File> writeAsString(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) =>
      _file.writeAsString(contents,
          mode: mode, encoding: encoding, flush: flush);

  @override
  void writeAsStringSync(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) =>
      _file.writeAsStringSync(contents,
          mode: mode, encoding: encoding, flush: flush);
} */
