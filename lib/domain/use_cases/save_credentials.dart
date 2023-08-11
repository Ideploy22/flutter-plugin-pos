import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class SaveCredentialsUseCase {
  final PosRepository _repository;

  SaveCredentialsUseCase({required PosRepository repository}) : _repository = repository;

  Future<EitherOf<Failure, VoidSuccess>> call(Map<String, dynamic> credentials) {
    return _repository.saveCredentials(credentials);
  }
}
