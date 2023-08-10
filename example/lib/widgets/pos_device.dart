import 'package:flutter/material.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';

class PosDeviceWidget extends StatelessWidget {
  final PosDevice device;
  final bool connected;
  final void Function() onRequestConnection;
  final void Function() onRequestCharge;

  const PosDeviceWidget({
    required this.connected,
    required this.device,
    required this.onRequestConnection,
    required this.onRequestCharge,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          device.name,
          style: const TextStyle(color: Colors.red, fontSize: 20),
        ),
        const SizedBox(width: 16.0),
        connected
            ? const Text('Connected')
            : ElevatedButton(
                onPressed: () => onRequestConnection(),
                child: const Text('Connect'),
              ),
        const SizedBox(width: 16.0),
        if (connected)
          ElevatedButton(
            onPressed: () => onRequestCharge(),
            child: const Text('Charge'),
          ),
      ],
    );
  }
}
