import 'package:dartz/dartz.dart';

import '../../entities/auth/change_password.dart';


abstract class ChangePasswordRepository {
  Future<Either<String, ChangePasswordEntity>> changePassword(
      String email,
      String oldPassword,
      String newPassword,
      );
}