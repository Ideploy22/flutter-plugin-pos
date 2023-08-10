import 'package:flutter_plugin_pos_integration/domain/entities/pos_device/pos_device.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class GetDevicesUseCase {
  final PosRepository _repository;

  GetDevicesUseCase({required PosRepository repository}) : _repository = repository;

  EitherOf<Failure, List<PosDevice>> call(List<dynamic> data) {
    return _repository.getDevices(data);
  }
}
