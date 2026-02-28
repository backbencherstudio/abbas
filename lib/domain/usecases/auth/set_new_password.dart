import 'package:dartz/dartz.dart';

import '../../entities/auth/set_new_password.dart';
import '../../repositories/auth/set_new_password_repository.dart';



class SetNewPasswordUseCase {
  final SetNewPasswordRepository repository;

  SetNewPasswordUseCase({required this.repository});

  Future<Either<String, SetNewPasswordEntity>> execute(
      String email,
      String otp,
      String newPassword,
      ) async {
    return await repository.setNewPassword(email, otp, newPassword);
  }
}