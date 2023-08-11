import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:ideploy_package/ideploy_package.dart';

abstract class PosRepository {
  EitherOf<Failure, List<PosDevice>> getDevices(List<dynamic> data);
  String deviceToString(PosDevice device);
  String chargeToString(PosCharge charge);
  PaymentResponse makePaymentResponse(Map<String, dynamic> data);
  Future<EitherOf<Failure, PosDevice?>> getPairedDevice();
  Future<EitherOf<Failure, VoidSuccess>> pairDevice(PosDevice device);
  Future<EitherOf<Failure, PosCredentials?>> getCredentials();
  Future<EitherOf<Failure, VoidSuccess>> saveCredentials(Map<String, dynamic> credentials);
}
