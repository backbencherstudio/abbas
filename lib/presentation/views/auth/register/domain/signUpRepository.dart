
import 'UserEntity.dart';

abstract class SignUpRepository {
  Future<SignupResult> signUp(
    String name,
    String email,
    String password,
  );
}
