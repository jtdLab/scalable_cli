import 'package:scalable_cli/src/core/injection_config_file.dart';
import 'package:scalable_cli/src/core/platform.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const noRouterInjectionConfigFile = '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../application/advanced/current_time/current_time_bloc.dart' as _i16;
import '../application/advanced/echo_email/echo_email_bloc.dart' as _i17;
import '../application/home/counter/counter_cubit.dart' as _i4;
import '../domain/current_time/i_current_time_service.dart' as _i5;
import '../domain/echo_email/i_echo_email_service.dart' as _i7;
import '../infrastructure/core/third_party_dependencies.dart' as _i18;
import '../infrastructure/current_time/locale_current_time_service.dart' as _i6;
import '../infrastructure/echo_email/fake_echo_email_service.dart' as _i9;
import '../infrastructure/echo_email/postman_echo_email_service.dart' as _i8;

const String _test = 'test';
const String _prod = 'prod';
const String _dev = 'dev';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt \$initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyDependencies = _\$ThirdPartyDependencies();
  gh.lazySingleton<_i3.Client>(() => thirdPartyDependencies.httpClient);
  gh.factory<_i4.CounterCubit>(() => _i4.CounterCubit());
  gh.lazySingleton<_i5.ICurrentTimeService>(
      () => _i6.LocaleCurrentTimeService());
  gh.lazySingleton<_i7.IEchoEmailService>(
      () => _i8.PostmanEmailEchoService(get<_i3.Client>()),
      registerFor: {_test, _prod});
  gh.lazySingleton<_i7.IEchoEmailService>(() => _i9.FakeEchoEmailService(),
      registerFor: {_dev});
  gh.factory<_i16.CurrentTimeBloc>(
      () => _i16.CurrentTimeBloc(get<_i5.ICurrentTimeService>()));
  gh.factory<_i17.EchoEmailBloc>(
      () => _i17.EchoEmailBloc(get<_i7.IEchoEmailService>()));
  return get;
}

class _\$ThirdPartyDependencies extends _i18.ThirdPartyDependencies {}
''';

const oneRouterInjectionConfigFile = '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../application/advanced/current_time/current_time_bloc.dart' as _i16;
import '../application/advanced/echo_email/echo_email_bloc.dart' as _i17;
import '../application/home/counter/counter_cubit.dart' as _i4;
import '../domain/current_time/i_current_time_service.dart' as _i5;
import '../domain/echo_email/i_echo_email_service.dart' as _i7;
import '../infrastructure/core/third_party_dependencies.dart' as _i18;
import '../infrastructure/current_time/locale_current_time_service.dart' as _i6;
import '../infrastructure/echo_email/fake_echo_email_service.dart' as _i9;
import '../infrastructure/echo_email/postman_echo_email_service.dart' as _i8;
import '../presentation/android/core/router.dart' as _i19;

const String _test = 'test';
const String _prod = 'prod';
const String _dev = 'dev';
const String _android = 'android';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt \$initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyDependencies = _\$ThirdPartyDependencies();
  gh.lazySingleton<_i3.Client>(() => thirdPartyDependencies.httpClient);
  gh.factory<_i4.CounterCubit>(() => _i4.CounterCubit());
  gh.lazySingleton<_i5.ICurrentTimeService>(
      () => _i6.LocaleCurrentTimeService());
  gh.lazySingleton<_i7.IEchoEmailService>(
      () => _i8.PostmanEmailEchoService(get<_i3.Client>()),
      registerFor: {_test, _prod});
  gh.lazySingleton<_i7.IEchoEmailService>(() => _i9.FakeEchoEmailService(),
      registerFor: {_dev});
  gh.factory<_i16.CurrentTimeBloc>(
      () => _i16.CurrentTimeBloc(get<_i5.ICurrentTimeService>()));
  gh.factory<_i17.EchoEmailBloc>(
      () => _i17.EchoEmailBloc(get<_i7.IEchoEmailService>()));
  gh.lazySingleton<_i19.Router>(() => _i19.Router(), registerFor: {_android});
  return get;
}

class _\$ThirdPartyDependencies extends _i18.ThirdPartyDependencies {}
''';

const multipleRouterInjectionConfigFile = '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../application/advanced/current_time/current_time_bloc.dart' as _i16;
import '../application/advanced/echo_email/echo_email_bloc.dart' as _i17;
import '../application/home/counter/counter_cubit.dart' as _i4;
import '../domain/current_time/i_current_time_service.dart' as _i5;
import '../domain/echo_email/i_echo_email_service.dart' as _i7;
import '../infrastructure/core/third_party_dependencies.dart' as _i18;
import '../infrastructure/current_time/locale_current_time_service.dart' as _i6;
import '../infrastructure/echo_email/fake_echo_email_service.dart' as _i9;
import '../infrastructure/echo_email/postman_echo_email_service.dart' as _i8;
import '../presentation/android/core/router.dart' as _i19;
import '../presentation/macos/core/router.dart' as _i20;

const String _test = 'test';
const String _prod = 'prod';
const String _dev = 'dev';
const String _android = 'android';
const String _macos = 'macos';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt \$initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyDependencies = _\$ThirdPartyDependencies();
  gh.lazySingleton<_i3.Client>(() => thirdPartyDependencies.httpClient);
  gh.factory<_i4.CounterCubit>(() => _i4.CounterCubit());
  gh.lazySingleton<_i5.ICurrentTimeService>(
      () => _i6.LocaleCurrentTimeService());
  gh.lazySingleton<_i7.IEchoEmailService>(
      () => _i8.PostmanEmailEchoService(get<_i3.Client>()),
      registerFor: {_test, _prod});
  gh.lazySingleton<_i7.IEchoEmailService>(() => _i9.FakeEchoEmailService(),
      registerFor: {_dev});
  gh.factory<_i16.CurrentTimeBloc>(
      () => _i16.CurrentTimeBloc(get<_i5.ICurrentTimeService>()));
  gh.factory<_i17.EchoEmailBloc>(
      () => _i17.EchoEmailBloc(get<_i7.IEchoEmailService>()));
  gh.lazySingleton<_i19.Router>(() => _i19.Router(), registerFor: {_android});
  gh.lazySingleton<_i20.Router>(() => _i20.Router(), registerFor: {_macos});
  return get;
}

class _\$ThirdPartyDependencies extends _i18.ThirdPartyDependencies {}
''';

void main() {
  group('InjectionConfigFile', () {
    final cwd = Directory.current;

    setUp(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is "lib/core/injection.config.dart"', () {
        final injectionConfigFile = InjectionConfigFile();
        expect(
          injectionConfigFile.path,
          'lib/core/injection.config.dart',
        );
      });
    });

    group('file', () {
      test('has path "lib/core/injection.config.dart"', () {
        final injectionConfigFile = InjectionConfigFile();
        expect(
          injectionConfigFile.file.path,
          'lib/core/injection.config.dart',
        );
      });
    });

    group('addCoverageIgnoreFile', () {
      const content = '''
abc
def
ghi
''';

      test('adds coverage:ignore-file directive on top of the file.', () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/core/injection.config.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(content);

        final injectionConfigFile = InjectionConfigFile();
        injectionConfigFile.addCoverageIgnoreFile();

        final fileContent = injectionConfigFile.file.readAsLinesSync();
        expect(
          fileContent,
          [
            '// coverage:ignore-file',
            '',
            'abc',
            'def',
            'ghi',
          ],
        );
      });
    });

    group('addRouter', () {
      test(
          'does not change the undelying file content if the router of the given platform was already added',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/core/injection.config.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(oneRouterInjectionConfigFile);

        final injectionConfigFile = InjectionConfigFile();
        injectionConfigFile.addRouter(Platform.android);

        final fileContent = injectionConfigFile.file.readAsStringSync();
        expect(fileContent, oneRouterInjectionConfigFile);
      });

      test(
          'updates the underlying file content correctly (no router added yet)',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/core/injection.config.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(noRouterInjectionConfigFile);

        final injectionConfigFile = InjectionConfigFile();
        injectionConfigFile.addRouter(Platform.android);

        final fileContent = injectionConfigFile.file.readAsStringSync();
        expect(fileContent, oneRouterInjectionConfigFile);
      });

      test(
          'updates the underlying file content correctly (one router added already)',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/core/injection.config.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(oneRouterInjectionConfigFile);

        final injectionConfigFile = InjectionConfigFile();
        injectionConfigFile.addRouter(Platform.macos);

        final fileContent = injectionConfigFile.file.readAsStringSync();
        expect(fileContent, multipleRouterInjectionConfigFile);
      });

      test(
          'updates the underlying file content correctly (multiple router added already)',
          () {
        final tempDir = Directory.systemTemp.createTempSync();
        Directory.current = tempDir.path;
        final file = File('lib/core/injection.config.dart');
        file.createSync(recursive: true);
        file.writeAsStringSync(multipleRouterInjectionConfigFile);

        final injectionConfigFile = InjectionConfigFile();
        injectionConfigFile.addRouter(Platform.windows);

        final fileContent = injectionConfigFile.file.readAsStringSync();
        expect(
          fileContent,
          '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../application/advanced/current_time/current_time_bloc.dart' as _i16;
import '../application/advanced/echo_email/echo_email_bloc.dart' as _i17;
import '../application/home/counter/counter_cubit.dart' as _i4;
import '../domain/current_time/i_current_time_service.dart' as _i5;
import '../domain/echo_email/i_echo_email_service.dart' as _i7;
import '../infrastructure/core/third_party_dependencies.dart' as _i18;
import '../infrastructure/current_time/locale_current_time_service.dart' as _i6;
import '../infrastructure/echo_email/fake_echo_email_service.dart' as _i9;
import '../infrastructure/echo_email/postman_echo_email_service.dart' as _i8;
import '../presentation/android/core/router.dart' as _i19;
import '../presentation/macos/core/router.dart' as _i20;
import '../presentation/windows/core/router.dart' as _i21;

const String _test = 'test';
const String _prod = 'prod';
const String _dev = 'dev';
const String _android = 'android';
const String _macos = 'macos';
const String _windows = 'windows';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt \$initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyDependencies = _\$ThirdPartyDependencies();
  gh.lazySingleton<_i3.Client>(() => thirdPartyDependencies.httpClient);
  gh.factory<_i4.CounterCubit>(() => _i4.CounterCubit());
  gh.lazySingleton<_i5.ICurrentTimeService>(
      () => _i6.LocaleCurrentTimeService());
  gh.lazySingleton<_i7.IEchoEmailService>(
      () => _i8.PostmanEmailEchoService(get<_i3.Client>()),
      registerFor: {_test, _prod});
  gh.lazySingleton<_i7.IEchoEmailService>(() => _i9.FakeEchoEmailService(),
      registerFor: {_dev});
  gh.factory<_i16.CurrentTimeBloc>(
      () => _i16.CurrentTimeBloc(get<_i5.ICurrentTimeService>()));
  gh.factory<_i17.EchoEmailBloc>(
      () => _i17.EchoEmailBloc(get<_i7.IEchoEmailService>()));
  gh.lazySingleton<_i19.Router>(() => _i19.Router(), registerFor: {_android});
  gh.lazySingleton<_i20.Router>(() => _i20.Router(), registerFor: {_macos});
  gh.lazySingleton<_i21.Router>(() => _i21.Router(), registerFor: {_windows});
  return get;
}

class _\$ThirdPartyDependencies extends _i18.ThirdPartyDependencies {}
''',
        );
      });
    });

    group('replaceGetItAndInjectableImportsWithScalabeCore', () {
      // TODO
    });
  });
}
