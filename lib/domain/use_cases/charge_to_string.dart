import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class ChargeToStringUseCase {
  final PosRepository _repository;

  ChargeToStringUseCase({required PosRepository repository}) : _repository = repository;

  String call(PosCharge charge) {
    return _repository.chargeToString(charge);
  }
}
