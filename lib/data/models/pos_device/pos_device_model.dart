import 'package:flutter_plugin_pos_integration/constants.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pos_device_model.g.dart';
part 'pos_device_model.mapper.dart';

@JsonSerializable(anyMap: true)
class PosDeviceModel extends PosDevice {
  @JsonKey(
    name: 'family',
    fromJson: _$PosDeviceFamilyFromJson,
    toJson: _$PosDeviceFamilyToJson,
  )
  final PosDeviceFamily familyModel;

  PosDeviceModel({
    required String name,
    required String address,
    required this.familyModel,
  }) : super(
          name: name,
          address: address,
          family: familyModel,
        );

  factory PosDeviceModel.fromJson(Map<String, dynamic> json) => _$PosDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PosDeviceModelToJson(this);

  factory PosDeviceModel.fromEntity(PosDevice entity) => _$PosDeviceModelFromEntity(entity);

  PosDevice toEntity() => _$PosDeviceModelToEntity(this);
}
