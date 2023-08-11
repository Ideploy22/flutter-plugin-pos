import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_payment_type.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/flutter_plugin_pos_integration.dart';
import 'package:flutter_plugin_pos_integration_example/widgets/devices.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _posPlugin = FlutterPluginPosIntegration();
  bool _scanning = false;
  PosDevice? _deviceConnected;
  String? _loginMessage;
  String? _terminalName;
  PosPaymentResponse? _paymentResponse;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> _getPairedDevice() async {
    _deviceConnected = await _posPlugin.pairedDevice;
    setState(() {});
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    if (!await Permission.bluetoothScan.isGranted) {
      await Permission.bluetoothScan.request();
    }

    if (!await Permission.bluetoothConnect.isGranted) {
      await Permission.bluetoothConnect.request();
    }

    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }

    await _posPlugin.initialize();
    await _getPairedDevice();

    _posPlugin.scanning.listen((event) {
      if (mounted) {
        setState(() {
          _scanning = event;
        });
      }
    });

    _posPlugin.paymentResponse.listen((PosPaymentResponse event) {
      if (mounted) {
        setState(() {
          _paymentResponse = event;
        });
      }
    });

    _posPlugin.pairStatus.listen((PosPairStatus event) {
      if (mounted) {
        if (event == PosPairStatus.pair) {
          _getPairedDevice();
        }
      }
    });

    _posPlugin.loginStatus.listen((PosLoginStatus event) {
      if (mounted) {
        if (event == PosLoginStatus.requestToken) {
          setState(() {
            _loginMessage = 'Requisitando token...';
          });
        } else if (event == PosLoginStatus.waitingValidateToken) {
          setState(() {
            _loginMessage = 'Valide o token: ${_posPlugin.token} no dashboard Zoop';
          });
        } else if (event == PosLoginStatus.error) {
          setState(() {
            _loginMessage = 'Erro ao logar';
          });
        } else if (event == PosLoginStatus.success) {
          setState(() {
            _loginMessage = 'Login realizado com sucesso';
          });
        }
      }
    });

    _terminalName = await _posPlugin.terminalName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16.0),
            Center(
              child: _terminalName == null
                  ? const Text('Você precisa realizar login para continuar...')
                  : Text('Vendedor: ${_terminalName}'),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: _deviceConnected == null
                  ? const Text('Você precisa parear uma POS para continuar...')
                  : Text('POS: ${_deviceConnected?.name}'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('LOGIN'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _charge(),
              child: Text('CHARGE'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _toggleScan,
              child: Text(_scanning ? 'STOP SCAN' : 'SCAN'),
            ),
            const SizedBox(height: 16.0),
            const Text('Devices:'),
            PosDevices(
              scanning: _scanning,
              devices: _posPlugin.devices,
              deviceConnected: _deviceConnected,
              onRequestConnection: (PosDevice device) => _onRequestConnection(device),
              onRequestCharge: (PosDevice device) => _charge(),
            ),
            if (_loginMessage != null) ...[
              const SizedBox(height: 16.0),
              Text(_loginMessage!),
            ],
            if (_paymentResponse != null) ...[
              const SizedBox(height: 16.0),
              if (_paymentResponse?.status == PaymentStatusType.error)
                Text(_paymentResponse?.terminalMessage ?? 'Erro ao processar pagamento'),
              if (_paymentResponse?.status == PaymentStatusType.processing)
                Text(_paymentResponse?.terminalMessage ?? 'Processando pagamento...'),
              if (_paymentResponse?.status == PaymentStatusType.success)
                Text(_paymentResponse?.details?.approvalMessage ?? 'Pagamento realizado com sucesso!'),
            ]
          ],
        ),
      ),
    );
  }

  void _toggleScan() {
    if (!_scanning) {
      _posPlugin.startScan();
    }
  }

  Future<void> _onRequestConnection(PosDevice device) async {
    try {
      await _posPlugin.requestConnection(device);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _charge() async {
    try {
      const PosCharge charge = PosCharge(
        value: 10,
        paymentOption: PaymentType.credit, // credit
        installments: 1,
      );

      await _posPlugin.charge(charge);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _login() async {
    await _posPlugin.login();
  }
}
