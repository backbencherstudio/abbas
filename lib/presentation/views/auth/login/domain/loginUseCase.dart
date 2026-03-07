import 'loginEntity.dart';
import 'loginRepository.dart';
class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  Future<LoginEntity> call(String email, String password) {
    return loginRepository.login(
      email: email,
      password: password,
    );
  }
}