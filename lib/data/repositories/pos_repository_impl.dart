import 'package:flutter_plugin_pos_integration/data/data_sources/pos_data_source.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@Injectable(as: PosRepository)
class PosRepositoryImpl implements PosRepository {
  final PosDataSource _dataSource;

  PosRepositoryImpl({required PosDataSource dataSource}) : _dataSource = dataSource;

  @override
  EitherOf<Failure, List<PosDevice>> getDevices(List<dynamic> data) {
    try {
      return resolve(_dataSource.getDevices(data));
    } catch (e) {
      return reject(PosFailure(message: e.toString()));
    }
  }

  @override
  String deviceToString(PosDevice device) {
    return _dataSource.deviceToString(device);
  }

  @override
  String chargeToString(PosCharge charge) {
    return _dataSource.chargeToString(charge);
  }

  @override
  Future<EitherOf<Failure, PosDevice?>> getPairedDevice() async {
    try {
      final device = await _dataSource.getPairedDevice();
      return resolve(device);
    } catch (error) {
      return reject(PosFailure());
    }
  }

  @override
  Future<EitherOf<Failure, VoidSuccess>> pairDevice(PosDevice device) async {
    try {
      await _dataSource.pairDevice(device);
      return resolve(voidSuccess);
    } catch (error) {
      return reject(PosFailure());
    }
  }
}
