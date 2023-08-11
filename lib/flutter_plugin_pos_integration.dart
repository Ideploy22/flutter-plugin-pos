import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';

import 'flutter_plugin_pos_integration_platform_interface.dart';

class FlutterPluginPosIntegration {
  Future<String?> getPlatformVersion() {
    return FlutterPluginPosIntegrationPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize() {
    return FlutterPluginPosIntegrationPlatform.instance.initialize();
  }

  Future<void> login() {
    return FlutterPluginPosIntegrationPlatform.instance.login();
  }

  Future<void> startScan() {
    return FlutterPluginPosIntegrationPlatform.instance.startScan();
  }

  Future<void> requestConnection(PosDevice device) {
    return FlutterPluginPosIntegrationPlatform.instance.requestConnection(device);
  }

  Future<void> charge(PosCharge data) {
    return FlutterPluginPosIntegrationPlatform.instance.charge(data);
  }

  Stream<PosDevice> get devices => FlutterPluginPosIntegrationPlatform.instance.devices;
  Stream<PaymentResponse> get paymentResponse => FlutterPluginPosIntegrationPlatform.instance.paymentResponse;
  Stream<bool> get scanning => FlutterPluginPosIntegrationPlatform.instance.scanning;
  Stream<PosPairStatus> get pairStatus => FlutterPluginPosIntegrationPlatform.instance.pairStatus;
  Future<PosDevice?> get pairedDevice => FlutterPluginPosIntegrationPlatform.instance.pairedDevice;
  Future<PosCredentials?> get credentials => FlutterPluginPosIntegrationPlatform.instance.credentials;
  Stream<PosLoginStatus> get loginStatus => FlutterPluginPosIntegrationPlatform.instance.loginStatus;
  String? get token => FlutterPluginPosIntegrationPlatform.instance.token;
  Future<String?> get terminalName => FlutterPluginPosIntegrationPlatform.instance.terminalName;
}
