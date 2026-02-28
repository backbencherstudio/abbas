import 'package:dartz/dartz.dart';

import '../../entities/auth/set_new_password.dart';


abstract class SetNewPasswordRepository {
  Future<Either<String, SetNewPasswordEntity>> setNewPassword(
      String email,
      String otp,
      String newPassword,
      );
}