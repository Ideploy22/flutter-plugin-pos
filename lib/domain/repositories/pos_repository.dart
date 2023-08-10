import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:ideploy_package/ideploy_package.dart';

abstract class PosRepository {
  EitherOf<Failure, List<PosDevice>> getDevices(List<dynamic> data);
  String deviceToString(PosDevice device);
  String chargeToString(PosCharge charge);
  Future<EitherOf<Failure, PosDevice?>> getPairedDevice();
  Future<EitherOf<Failure, VoidSuccess>> pairDevice(PosDevice device);
}
