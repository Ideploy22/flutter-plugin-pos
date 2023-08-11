import 'dart:async';

import 'package:flutter_plugin_pos_integration/constants.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_message.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/charge_to_string.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/device_to_string.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/get_credentials.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/get_devices.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/get_paired_device.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/make_payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/pair_device.dart';
import 'package:flutter_plugin_pos_integration/domain/use_cases/save_credentials.dart';
import 'package:ideploy_package/ideploy_package.dart';

@lazySingleton
class PosController {
  final GetDevicesUseCase _getDevicesUseCase;
  final DeviceToStringUseCase _deviceToStringUseCase;
  final ChargeToStringUseCase _chargeToStringUseCase;
  final GetPairedDeviceUseCase _getPairedDeviceUseCase;
  final PairDeviceUseCase _pairDeviceUseCase;
  final SaveCredentialsUseCase _saveCredentialsUseCase;
  final GetCredentialsUseCase _getCredentialsUseCase;
  final MakePaymentResponseUseCase _makePaymentResponseUseCase;

  PosController({
    required GetDevicesUseCase getDevicesUseCase,
    required DeviceToStringUseCase deviceToStringUseCase,
    required ChargeToStringUseCase chargeToStringUseCase,
    required GetPairedDeviceUseCase getPairedDeviceUseCase,
    required PairDeviceUseCase pairDeviceUseCase,
    required SaveCredentialsUseCase saveCredentialsUseCase,
    required GetCredentialsUseCase getCredentialsUseCase,
    required MakePaymentResponseUseCase makePaymentResponseUseCase,
  })  : _getDevicesUseCase = getDevicesUseCase,
        _deviceToStringUseCase = deviceToStringUseCase,
        _getPairedDeviceUseCase = getPairedDeviceUseCase,
        _pairDeviceUseCase = pairDeviceUseCase,
        _saveCredentialsUseCase = saveCredentialsUseCase,
        _getCredentialsUseCase = getCredentialsUseCase,
        _chargeToStringUseCase = chargeToStringUseCase,
        _makePaymentResponseUseCase = makePaymentResponseUseCase;

  final StreamController<PosDevice> _devicesController = StreamController<PosDevice>.broadcast();
  Stream<PosDevice> get devicesStream => _devicesController.stream;

  final StreamController<PosPairStatus> _pairStatusStreamController = StreamController<PosPairStatus>.broadcast();
  Stream<PosPairStatus> get pairStatusStream => _pairStatusStreamController.stream;

  final StreamController<PosLoginStatus> _loginStatusStreamController = StreamController<PosLoginStatus>.broadcast();
  Stream<PosLoginStatus> get loginStatusStream => _loginStatusStreamController.stream;

  final StreamController<Failure> _failureController = StreamController<Failure>.broadcast();
  Stream<Failure> get failuresStream => _failureController.stream;

  final StreamController<PosPaymentResponse> _paymentResponseController =
      StreamController<PosPaymentResponse>.broadcast();
  Stream<PosPaymentResponse> get paymentResponse => _paymentResponseController.stream;

  final StreamController<bool> _scanningController = StreamController<bool>.broadcast();
  Stream<bool> get scanning => _scanningController.stream;

  PosDevice? _device;

  String? _token;
  String? get token => _token;

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

  static const List<String> errorMessages = <String>[
    'Não foi possível conectar. Por favor tente novamente',
  ];

  void handlePaymentMessage(Map<String, dynamic> json) {
    PaymentMessage? message;
    if (json['success'] == true) {
      message = PaymentMessage.fromRawMessage(json);
    } else {
      message = PaymentMessage(
        event: POSEvent.terminalMessage,
        message: json['error'],
        terminalMessageType: PaymentMessageType.error,
      );
    }
    _paymentResponseController.add(
      PosPaymentResponse(
        status: json['success'] == true ? PaymentStatusType.processing : PaymentStatusType.error,
        terminalMessage: message,
      ),
    );
  }

  void handlePaymentResponse(Map<String, dynamic> json) {
    if (json['success'] == false) {
      _paymentResponseController.add(
        PosPaymentResponse(
          status: PaymentStatusType.error,
          terminalMessage: PaymentMessage(
            event: POSEvent.terminalMessage,
            message: json['error'],
            terminalMessageType: PaymentMessageType.error,
          ),
        ),
      );
    } else if (json['success'] == true && json['data']['status'] == 'start') {
      _paymentResponseController.add(
        PosPaymentResponse(
          status: PaymentStatusType.processing,
          terminalMessage: PaymentMessage(
            event: POSEvent.terminalMessage,
            message: 'Iniciando pagamento...',
            terminalMessageType: PaymentMessageType.display,
          ),
        ),
      );
    } else if (json['success'] == true && json['data']['status'] == 'success') {
      final response = _makePaymentResponseUseCase(json['data']['detail']);
      _paymentResponseController.add(response);
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

  void _errorLogin() {
    _loginStatusStreamController.add(PosLoginStatus.error);
  }

  Future<void> handleLoginStatus(Map<String, dynamic> json) async {
    if (json['success'] == false) {
      _errorLogin();
    } else {
      if (json['data']['status'] == 'requestToken') {
        _loginStatusStreamController.add(PosLoginStatus.requestToken);
      } else if (json['data']['status'] == 'waitingValidateToken') {
        _token = json['data']['token'];
        _loginStatusStreamController.add(PosLoginStatus.waitingValidateToken);
      } else if (json['data']['status'] == 'logged') {
        final response = await _saveCredentialsUseCase.call(json['data']);
        response.get((reject) => _errorLogin(), (resolve) => _loginStatusStreamController.add(PosLoginStatus.success));
      }
    }
  }

  Future<PosCredentials?> getCredentials() async {
    final response = await _getCredentialsUseCase.call();
    return response.get((reject) => null, (credentials) => credentials);
  }
}
