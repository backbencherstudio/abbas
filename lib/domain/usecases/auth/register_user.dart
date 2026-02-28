import '../../entities/auth/register.dart';
import '../../repositories/auth/register_repository.dart';

class RegisterUser {
  late final RegisterRepository repository;

  RegisterUser(this.repository);

  Future<Register> call(String email, String password) async {
    return await repository.register(email, password);
  }
}
