import 'package:dartz/dartz.dart';


import '../../../../domain/repositories/auth/set_new_password_repository.dart';
import '../../../domain/entities/auth/set_new_password.dart';
import '../../datasources/auth/set_new_password_datasource.dart';


class SetNewPasswordRepositoryImpl implements SetNewPasswordRepository {
  final SetNewPasswordDataSource dataSource;

  SetNewPasswordRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, SetNewPasswordEntity>> setNewPassword(
      String email,
      String otp,
      String newPassword,
      ) async {
    try {
      print('Setting new password for: $email');
      print('Using OTP: $otp');

      final response = await dataSource.setNewPassword(email, otp, newPassword);

      if (response.success) {
        print('Password reset successfully');
        return Right(SetNewPasswordEntity(success: response.success, message: response.message));
      } else {
        print('Password reset failed: ${response.message}');
        return Left(response.message);
      }
    } catch (e) {
      print('Password reset error: $e');
      return Left(e.toString());
    }
  }
}