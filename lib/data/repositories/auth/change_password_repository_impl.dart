import 'package:dartz/dartz.dart';


import '../../../domain/entities/auth/change_password.dart';
import '../../../domain/repositories/auth/change_password_repository.dart';
import '../../datasources/auth/change_password_datasource.dart';


class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordDataSource dataSource;

  ChangePasswordRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, ChangePasswordEntity>> changePassword(
      String email,
      String oldPassword,
      String newPassword,
      ) async {
    try {
      print('Changing password for: $email');
      final response = await dataSource.changePassword(email, oldPassword, newPassword);

      if (response.success) {
        print('Password changed successfully');
        return Right(ChangePasswordEntity(success: response.success, message: response.message));
      } else {
        print('Password change failed: ${response.message}');
        return Left(response.message);
      }
    } catch (e) {
      print('Password change error: $e');
      return Left(e.toString());
    }
  }
}