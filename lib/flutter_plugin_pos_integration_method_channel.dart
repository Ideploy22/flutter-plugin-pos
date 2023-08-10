import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_pos_integration/constants.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/connection/connection.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment_message/payment_message.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/presentation/controller/pos_controller.dart';
import 'package:ideploy_package/ideploy_package.dart';

import 'di/injectable.dart';
import 'di/injectable.dart' as di;
import 'flutter_plugin_pos_integration_platform_interface.dart';

class MethodChannelFlutterPluginPosIntegration extends FlutterPluginPosIntegrationPlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('$nameSpace/$methods');

  @visibleForTesting
  EventChannel eventChannel = const EventChannel('$nameSpace/$eventChannelId');

  void _initializeLocatorIfNeeded() async {
    if (!locator.isRegistered<PosController>()) {
      di.init();
    }
  }

  @override
  Stream<PosDevice> get devices {
    _initializeLocatorIfNeeded();
    return locator<PosController>().devicesStream;
  }

  @override
  Future<PosDevice?> get pairedDevice {
    _initializeLocatorIfNeeded();
    return locator<PosController>().getPairedDevice();
  }

  @override
  Stream<PosPairStatus> get pairStatus {
    _initializeLocatorIfNeeded();
    return locator<PosController>().pairStatusStream;
  }

  @override
  Stream<PaymentMessage> get paymentMessages {
    _initializeLocatorIfNeeded();
    return locator<PosController>().paymentStream;
  }

  @override
  Stream<bool> get scanning {
    _initializeLocatorIfNeeded();
    return locator<PosController>().scanning;
  }

  Stream<Failure> get failuresStream {
    _initializeLocatorIfNeeded();
    return locator<PosController>().failuresStream;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final String? version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  void _mapEventToState(dynamic data) {
    if (data.runtimeType == String) {
      print('***************************');
      print(data);
      print('***************************\n\n');

      final Map<String, dynamic> json = jsonDecode(data);
      final POSEvent event =
          POSEvent.values.firstWhere((POSEvent event) => event.name == json['type'], orElse: () => POSEvent.unknown);

      _initializeLocatorIfNeeded();
      final PosController posController = locator<PosController>();

      switch (event) {
        case POSEvent.scan:
          if (json['data']['start'] != null) {
            // print('start');
          } else if (json['data']['devices'] != null) {
            posController.getPosDevices(jsonDecode(json['data']['devices']));
            stopScan();
          } else {
            stopScan();
          }
          break;
        case POSEvent.pair:
          posController.handlePairStatus(json);
          break;
        case POSEvent.login:
          print('LOGIN $json');
          break;
        case POSEvent.paymentFailed:
        case POSEvent.paymentSuccessful:
        case POSEvent.paymentAborted:
        case POSEvent.terminalMessage:
          print('POSEVENT $json');
          // posController.handlePaymentMessage(json);
          break;
        default:
          // TODO: Handle this case.
          break;
      }
    }
  }

  @override
  Future<void> initialize() async {
    final connection = PosConnection(
      marketplaceId: '1b9d181fd7bf42959d005010fe053fff',
      sellerId: '4856ba68780d40cebea14343e0ba2d30',
      accessKey: 'c086c682-c307-4a06-8c0f-1b352f3dd6c5',
    );

    await methodChannel.invokeMethod<String>('initialize', connection.toString());
    // await methodChannel.invokeMethod<String>('initialize');
    eventChannel.receiveBroadcastStream().listen((dynamic event) => _mapEventToState(event));
  }

  @override
  Future<void> login() async {
    await methodChannel.invokeMethod<String>('login');
  }

  @override
  Future<void> startScan() async {
    _initializeLocatorIfNeeded();
    locator<PosController>().startScan();
    await methodChannel.invokeMethod<String>('startScan');
  }

  void stopScan() async {
    _initializeLocatorIfNeeded();
    locator<PosController>().stopScan();
  }

  @override
  Future<void> requestConnection(PosDevice device) async {
    _initializeLocatorIfNeeded();
    final PosController controller = locator<PosController>();
    controller.setDevice(device);
    final String stringDevice = controller.deviceToString(device);
    await methodChannel.invokeMethod<String>('requestConnection', stringDevice);
    stopScan();
  }

  @override
  Future<void> charge(PosCharge data) async {
    _initializeLocatorIfNeeded();
    final PosController controller = locator<PosController>();
    final String stringCharge = controller.chargeToString(data);
    await methodChannel.invokeMethod<String>('charge', stringCharge);
  }
}
