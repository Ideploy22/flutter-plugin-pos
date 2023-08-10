import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';

abstract class PosDataSource {
  List<PosDevice> getDevices(List<dynamic> data);
  String deviceToString(PosDevice device);
  String chargeToString(PosCharge charge);
  Future<PosDevice?> getPairedDevice();
  Future<void> pairDevice(PosDevice device);
}
