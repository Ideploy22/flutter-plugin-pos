import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class DeviceToStringUseCase {
  final PosRepository _repository;

  DeviceToStringUseCase({required PosRepository repository}) : _repository = repository;

  String call(PosDevice device) {
    return _repository.deviceToString(device);
  }
}
