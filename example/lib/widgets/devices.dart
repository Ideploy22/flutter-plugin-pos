import 'package:flutter/material.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration_example/widgets/pos_device.dart';

class PosDevices extends StatelessWidget {
  final bool scanning;
  final PosDevice? deviceConnected;
  final Stream<PosDevice> devices;
  final void Function(PosDevice) onRequestConnection;
  final void Function(PosDevice) onRequestCharge;

  const PosDevices({
    required this.scanning,
    required this.devices,
    required this.onRequestConnection,
    required this.onRequestCharge,
    this.deviceConnected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PosDevice>(
        stream: devices,
        builder: (
          BuildContext context,
          AsyncSnapshot<PosDevice> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting && scanning) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return PosDeviceWidget(
                connected: deviceConnected != null && deviceConnected?.address == snapshot.data?.address,
                device: snapshot.data!,
                onRequestConnection: () => onRequestConnection(snapshot.data!),
                onRequestCharge: () => onRequestCharge(snapshot.data!),
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return const Text('Waiting scan devices');
          }
        });
  }
}
