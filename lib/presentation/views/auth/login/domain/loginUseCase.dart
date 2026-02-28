import '../../../../../domain/repositories/auth/login_repository.dart';
import 'loginEntity.dart';
class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  Future<LoginEntity> call(String email, String password) {
    return loginRepository.login(email,password);
  }
}