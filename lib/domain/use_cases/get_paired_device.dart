import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class GetPairedDeviceUseCase {
  final PosRepository _repository;

  GetPairedDeviceUseCase({required PosRepository repository}) : _repository = repository;

  Future<EitherOf<Failure, PosDevice?>> call() {
    return _repository.getPairedDevice();
  }
}
