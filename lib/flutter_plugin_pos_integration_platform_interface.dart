import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_plugin_pos_integration_method_channel.dart';

abstract class FlutterPluginPosIntegrationPlatform extends PlatformInterface {
  FlutterPluginPosIntegrationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPluginPosIntegrationPlatform _instance = MethodChannelFlutterPluginPosIntegration();

  static FlutterPluginPosIntegrationPlatform get instance => _instance;

  static set instance(FlutterPluginPosIntegrationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> startScan() {
    throw UnimplementedError('startScan() has not been implemented.');
  }

  Future<void> requestConnection(PosDevice device) {
    throw UnimplementedError('requestConnection() has not been implemented.');
  }

  Future<void> charge(PosCharge data) {
    throw UnimplementedError('charge() has not been implemented.');
  }

  Future<void> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> login() {
    throw UnimplementedError('login() has not been implemented.');
  }

  Stream<PosDevice> get devices => throw UnimplementedError('devices stream has not been implemented.');
  Stream<PosPairStatus> get pairStatus => throw UnimplementedError('pairStatus stream has not been implemented.');
  Stream<PosLoginStatus> get loginStatus => throw UnimplementedError('loginStatus stream has not been implemented.');
  Future<PosDevice?> get pairedDevice => throw UnimplementedError('pairedDevice has not been implemented.');
  Stream<PosPaymentResponse> get paymentResponse =>
      throw UnimplementedError('payment response stream has not been implemented.');
  Stream<bool> get scanning => throw UnimplementedError('scanning devices stream state has not been implemented.');
  Future<PosCredentials?> get credentials => throw UnimplementedError('credentials has not been implemented.');
  Future<String?> get terminalName => throw UnimplementedError('terminalName has not been implemented.');
  String? get token => throw UnimplementedError('token has not been implemented.');
}
