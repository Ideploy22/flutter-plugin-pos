import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _platformVersion = 'Unknown';
  final _posPlugin = FlutterPluginPosIntegration();

  bool scanning = false;

  PosDevice? _deviceConnected;

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
    String platformVersion;
    try {
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

      platformVersion = await _posPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    _posPlugin.scanning.listen((event) {
      if (mounted) {
        setState(() {
          scanning = event;
        });
      }
    });

    _posPlugin.pairStatus.listen((event) {
      if (mounted) {
        if (event == PosPairStatus.pair) {
          _getPairedDevice();
        }
      }
    });

    setState(() {
      _platformVersion = platformVersion;
    });
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
            Center(
              child: Text('Running on: $_platformVersion\n'),
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
              child: Text(scanning ? 'STOP SCAN' : 'SCAN'),
            ),
            const SizedBox(height: 16.0),
            const Text('Devices:'),
            PosDevices(
              scanning: scanning,
              devices: _posPlugin.devices,
              deviceConnected: _deviceConnected,
              onRequestConnection: (PosDevice device) => _onRequestConnection(device),
              onRequestCharge: (PosDevice device) => _charge(),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleScan() {
    if (!scanning) {
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
