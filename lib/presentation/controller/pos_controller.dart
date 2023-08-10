import 'dart:async';

import 'package:flutter_plugin_pos_integration/constants.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment_message/payment_message.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/charge_to_string.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/device_to_string.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/get_devices.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/get_paired_device.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/pair_device.dart';
import 'package:ideploy_package/ideploy_package.dart';

@lazySingleton
class PosController {
  final GetDevicesUseCase _getDevicesUseCase;
  final DeviceToStringUseCase _deviceToStringUseCase;
  final ChargeToStringUseCase _chargeToStringUseCase;
  final GetPairedDeviceUseCase _getPairedDeviceUseCase;
  final PairDeviceUseCase _pairDeviceUseCase;

  PosController({
    required GetDevicesUseCase getDevicesUseCase,
    required DeviceToStringUseCase deviceToStringUseCase,
    required ChargeToStringUseCase chargeToStringUseCase,
    required GetPairedDeviceUseCase getPairedDeviceUseCase,
    required PairDeviceUseCase pairDeviceUseCase,
  })  : _getDevicesUseCase = getDevicesUseCase,
        _deviceToStringUseCase = deviceToStringUseCase,
        _getPairedDeviceUseCase = getPairedDeviceUseCase,
        _pairDeviceUseCase = pairDeviceUseCase,
        _chargeToStringUseCase = chargeToStringUseCase;

  final StreamController<PosDevice> _devicesController = StreamController<PosDevice>.broadcast();
  Stream<PosDevice> get devicesStream => _devicesController.stream;

  final StreamController<PosPairStatus> _pairStatusStreamController = StreamController<PosPairStatus>.broadcast();
  Stream<PosPairStatus> get pairStatusStream => _pairStatusStreamController.stream;

  final StreamController<Failure> _failureController = StreamController<Failure>.broadcast();
  Stream<Failure> get failuresStream => _failureController.stream;

  final StreamController<PaymentMessage> _paymentController = StreamController<PaymentMessage>.broadcast();
  Stream<PaymentMessage> get paymentStream => _paymentController.stream;

  final StreamController<bool> _scanningController = StreamController<bool>.broadcast();
  Stream<bool> get scanning => _scanningController.stream;

  PosDevice? _device;

  void startScan() {
    _scanningController.add(true);
  }

  void stopScan() {
    _scanningController.add(false);
  }

  void getPosDevices(
    List<dynamic> data,
  ) {
    final EitherOf<Failure, List<PosDevice>> response = _getDevicesUseCase.call(data);
    response.get(
      (Failure error) {
        _failureController.add(error);
        stopScan();
      },
      (List<PosDevice> list) {
        for (final PosDevice device in list) {
          _devicesController.add(device);
        }
      },
    );
  }

  String deviceToString(PosDevice device) {
    return _deviceToStringUseCase.call(device);
  }

  String chargeToString(PosCharge charge) {
    return _chargeToStringUseCase.call(charge);
  }

  static const List<String> ignoreMessages = <String>[
    'TRANSACTION_APPROVED',
    'TRANSACTION_DENIED',
    'CONNECTION_RELEASED',
    'ACTION_REMOVE_CARD',
    'ACTION',
  ];

  static const List<String> errorMessages = <String>[
    'Não foi possível conectar. Por favor tente novamente',
  ];

  void handlePaymentMessage(Map<String, dynamic> json) {
    final PaymentMessage message = PaymentMessage.fromRawMessage(json);
    if (message.event == POSEvent.terminalMessage && errorMessages.contains(message.data['message'])) {
      final PaymentMessage newMessage = PaymentMessage(
        event: POSEvent.paymentFailed,
        data: <String, dynamic>{
          'id': '-1',
          'responseCode': 'ERR_FPF',
          'error': <String, dynamic>{
            'status_code': -1,
            'message': message.data['message'],
            'category': 'plugin_message',
          },
        },
      );

      _paymentController.add(newMessage);
    } else if (message.event != POSEvent.terminalMessage ||
        (message.event == POSEvent.terminalMessage && !ignoreMessages.contains(message.data['terminalMessageType']))) {
      _paymentController.add(message);
    }
  }

  void _startPair() {
    _pairStatusStreamController.add(PosPairStatus.pairing);
  }

  void _successPair() {
    _pairStatusStreamController.add(PosPairStatus.pair);
  }

  void _errorPair() {
    _pairStatusStreamController.add(PosPairStatus.error);
  }

  Future<void> handlePairStatus(Map<String, dynamic> json) async {
    if (json['success'] == false) {
      _errorPair();
    } else {
      if (json['start'] == true) {
        _startPair();
      } else {
        final response = await _pairDeviceUseCase.call(_device!);
        response.get((reject) => _errorPair(), (resolve) => _successPair());
      }
    }
  }

  Future<PosDevice?> getPairedDevice() async {
    try {
      final response = await _getPairedDeviceUseCase.call();
      return response.get((reject) => null, (device) => device);
    } catch (error) {
      return null;
    }
  }

  void setDevice(PosDevice device) {
    _device = device;
  }
}
