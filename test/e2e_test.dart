@Tags(['e2e'])
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:scalable_cli/src/command_runner.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

void main() {
  group(
    'E2E',
    () {
      late Logger logger;
      late Progress progress;
      late ScalableCommandRunner commandRunner;

      void _removeTemporaryFiles() {
        try {
          Directory('.tmp').deleteSync(recursive: true);
        } catch (_) {}
      }

      setUpAll(_removeTemporaryFiles);
      tearDownAll(_removeTemporaryFiles);

      setUp(() {
        logger = MockLogger();

        logger = MockLogger();
        progress = MockProgress();
        when(() => logger.progress(any())).thenReturn(progress);

        commandRunner = ScalableCommandRunner(
          logger: logger,
        );
      });

      // TODO real tests
    },
    timeout: const Timeout(Duration(seconds: 90)),
  );
}
