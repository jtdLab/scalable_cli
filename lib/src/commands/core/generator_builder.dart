import 'package:mason/mason.dart';

/// A method which returns a [Future<MasonGenerator>] given a [MasonBundle].
typedef GeneratorBuilder = Future<MasonGenerator> Function(MasonBundle);
