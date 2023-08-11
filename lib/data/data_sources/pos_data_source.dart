import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';

abstract class PosDataSource {
  List<PosDevice> getDevices(List<dynamic> data);
  String deviceToString(PosDevice device);
  String chargeToString(PosCharge charge);
  Future<PosDevice?> getPairedDevice();
  Future<void> pairDevice(PosDevice device);
  Future<PosCredentials?> getCredentials();
  Future<void> saveCredentials(Map<String, dynamic> credentials);
  PosPaymentResponse makePaymentResponse(Map<String, dynamic> data);
}
