part of 'pos_device_model.dart';

PosDeviceModel _$PosDeviceModelFromEntity(PosDevice entity) => PosDeviceModel(
      name: entity.name,
      address: entity.address,
      familyModel: entity.family,
    );

PosDevice _$PosDeviceModelToEntity(PosDeviceModel model) => PosDevice(
      name: model.name,
      address: model.address,
      family: model.familyModel,
    );

PosDeviceFamily _$PosDeviceFamilyFromJson(String? value) {
  return PosDeviceFamily.values
      .firstWhere((element) => element.zoopName == value, orElse: () => PosDeviceFamily.classic);
}

String _$PosDeviceFamilyToJson(PosDeviceFamily family) {
  return family.zoopName;
}
