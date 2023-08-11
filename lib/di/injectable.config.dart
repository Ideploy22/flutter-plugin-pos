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
import '../domain/use_cases/charge_to_string.dart' as _i8;
import '../domain/use_cases/device_to_string.dart' as _i9;
import '../domain/use_cases/get_credentials.dart' as _i10;
import '../domain/use_cases/get_devices.dart' as _i11;
import '../domain/use_cases/get_paired_device.dart' as _i12;
import '../domain/use_cases/make_payment_response.dart' as _i13;
import '../domain/use_cases/pair_device.dart' as _i14;
import '../domain/use_cases/save_credentials.dart' as _i7;
import '../presentation/controller/pos_controller.dart' as _i15;

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
  gh.factory<_i7.SaveCredentialsUseCase>(
      () => _i7.SaveCredentialsUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i8.ChargeToStringUseCase>(
      () => _i8.ChargeToStringUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i9.DeviceToStringUseCase>(
      () => _i9.DeviceToStringUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i10.GetCredentialsUseCase>(
      () => _i10.GetCredentialsUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i11.GetDevicesUseCase>(
      () => _i11.GetDevicesUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i12.GetPairedDeviceUseCase>(
      () => _i12.GetPairedDeviceUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i13.MakePaymentResponseUseCase>(() =>
      _i13.MakePaymentResponseUseCase(repository: gh<_i5.PosRepository>()));
  gh.factory<_i14.PairDeviceUseCase>(
      () => _i14.PairDeviceUseCase(repository: gh<_i5.PosRepository>()));
  gh.lazySingleton<_i15.PosController>(() => _i15.PosController(
        getDevicesUseCase: gh<_i11.GetDevicesUseCase>(),
        deviceToStringUseCase: gh<_i9.DeviceToStringUseCase>(),
        chargeToStringUseCase: gh<_i8.ChargeToStringUseCase>(),
        getPairedDeviceUseCase: gh<_i12.GetPairedDeviceUseCase>(),
        pairDeviceUseCase: gh<_i14.PairDeviceUseCase>(),
        saveCredentialsUseCase: gh<_i7.SaveCredentialsUseCase>(),
        getCredentialsUseCase: gh<_i10.GetCredentialsUseCase>(),
        makePaymentResponseUseCase: gh<_i13.MakePaymentResponseUseCase>(),
      ));
  return getIt;
}
