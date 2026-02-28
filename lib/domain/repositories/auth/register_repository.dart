import '../../entities/auth/register.dart';

abstract class RegisterRepository {
  Future<Register> register(String email, String password);
}