import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class MakePaymentResponseUseCase {
  final PosRepository _repository;

  MakePaymentResponseUseCase({required PosRepository repository}) : _repository = repository;

  PosPaymentResponse call(Map<String, dynamic> data) {
    return _repository.makePaymentResponse(data);
  }
}
