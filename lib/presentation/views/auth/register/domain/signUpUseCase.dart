import 'package:abbas/presentation/views/auth/register/domain/signUpRepository.dart';
import 'UserEntity.dart';

class SignUpUseCase {
  final SignUpRepository signUpRepository;

  SignUpUseCase(this.signUpRepository);

  Future<SignupResult> call(
    String name,
    String email,
    String password,
  ) {
    return signUpRepository.signUp(name, email, password);
  }
}
