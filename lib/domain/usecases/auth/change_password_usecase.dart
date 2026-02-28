import 'package:dartz/dartz.dart';

import '../../entities/auth/change_password.dart';
import '../../repositories/auth/change_password_repository.dart';

class ChangePasswordUseCase {
  final ChangePasswordRepository repository;

  ChangePasswordUseCase({required this.repository});

  Future<Either<String, ChangePasswordEntity>> execute(
      String email,
      String oldPassword,
      String newPassword,
      ) async {
    return await repository.changePassword(email, oldPassword, newPassword);
  }
}