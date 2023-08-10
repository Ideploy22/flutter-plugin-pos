enum PosDeviceFamily {
  lowEnergy('LowEnergy'),
  classic('Classic');

  final String zoopName;

  const PosDeviceFamily(this.zoopName);
}

enum PosPairStatus { pairing, pair, error, idle }

class PosDevice {
  final String name;
  final String address;
  final PosDeviceFamily family;

  PosDevice({
    required this.name,
    required this.address,
    required this.family,
  });

  String get description => '$name: $address';
}
