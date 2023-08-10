// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosDeviceModel _$PosDeviceModelFromJson(Map json) => PosDeviceModel(
      name: json['name'] as String,
      address: json['address'] as String,
      familyModel: _$PosDeviceFamilyFromJson(json['family'] as String?),
    );

Map<String, dynamic> _$PosDeviceModelToJson(PosDeviceModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'family': _$PosDeviceFamilyToJson(instance.familyModel),
    };
