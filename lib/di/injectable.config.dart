// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/data_sources/pos_data_source.dart' as _i3;
import '../data/data_sources/pos_data_source_impl.dart' as _i4;
import '../data/repositories/pos_repository_impl.dart' as _i6;
import '../domain/repositories/pos_repository.dart' as _i5;
import '../domain/use_cases/charge_to_string.dart' as _i7;
import '../domain/use_cases/device_to_string.dart' as _i8;
import '../domain/use_cases/get_devices.dart' as _i9;
import '../domain/use_cases/get_paired_device.dart' as _i10;
import '../domain/use_cases/pair_device.dart' as _i11;
import '../presentation/controller/pos_controller.dart' as _i12;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.PosDataSource>(() => _i4.PosDataSourceImpl());
  gh.factory<_i5.PosRepository>(
      () => _i6.PosRepositoryImpl(dataSource: gh<_i3.PosDataSource>()));
  gh.factory<_i7.ChargeToStringUseCase>(
      () => _i7.ChargeToStringUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i8.DeviceToStringUseCase>(
      () => _i8.DeviceToStringUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i9.GetDevicesUseCase>(
      () => _i9.GetDevicesUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i10.GetPairedDeviceUseCase>(
      () => _i10.GetPairedDeviceUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i11.PairDeviceUseCase>(
      () => _i11.PairDeviceUseCase(repository: gh<_i5.PosRepository>()));
  gh.lazySingleton<_i12.PosController>(() => _i12.PosController(
        getDevicesUseCase: gh<_i9.GetDevicesUseCase>(),
        deviceToStringUseCase: gh<_i8.DeviceToStringUseCase>(),
        chargeToStringUseCase: gh<_i7.ChargeToStringUseCase>(),
        getPairedDeviceUseCase: gh<_i10.GetPairedDeviceUseCase>(),
        pairDeviceUseCase: gh<_i11.PairDeviceUseCase>(),
      ));
  return getIt;
}
