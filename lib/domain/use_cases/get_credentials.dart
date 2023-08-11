import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:flutter_plugin_pos_integration/domain/repositories/pos_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@injectable
class GetCredentialsUseCase {
  final PosRepository _repository;

  GetCredentialsUseCase({required PosRepository repository}) : _repository = repository;

  Future<EitherOf<Failure, PosCredentials?>> call() {
    return _repository.getCredentials();
  }
}
