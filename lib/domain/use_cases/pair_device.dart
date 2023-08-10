import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class PairDeviceUseCase {
  final PosRepository _repository;

  PairDeviceUseCase({required PosRepository repository}) : _repository = repository;

  Future<EitherOf<Failure, VoidSuccess>> call(PosDevice device) {
    return _repository.pairDevice(device);
  }
}
