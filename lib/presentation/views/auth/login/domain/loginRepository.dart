import 'loginEntity.dart';

abstract class LoginRepository {
  Future<LoginEntity> login({
    required String email,
    required String password,
  });
}