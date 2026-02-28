import 'package:abbas/presentation/views/auth/login/domain/loginEntity.dart';

import '../../entities/auth/login.dart';


abstract class LoginRepository {
  Future<LoginEntity> login(String email, String password);
}