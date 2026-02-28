// import 'package:dartz/dartz.dart';
//
// import '../../../domain/entities/auth/otp.dart';
// import '../../../domain/repositories/auth/otp_repository.dart';
// import '../../datasources/auth/otp_datasource.dart';
//
// class OTPRepositoryImpl implements OTPRepository {
//   final OTPDataSource dataSource;
//
//   OTPRepositoryImpl({required this.dataSource});
//
//   @override
//   Future<Either<String, OTPEntity>> sendOTP(String email) async {
//     try {
//       print('Sending OTP to: $email');
//       final response = await dataSource.sendOTP(email);
//       if (response.success) {
//         print('OTP sent successfully');
//         return Right(
//           OTPEntity(success: response.success, message: response.message),
//         );
//       } else {
//         print('OTP send failed: ${response.message}');
//         return Left(response.message);
//       }
//     } catch (e) {
//       print('OTP send error: $e');
//       return Left(e.toString());
//     }
//   }
//
//   @override
//   Future<Either<String, OTPEntity>> verifyOTP(String email, String otp) async {
//     try {
//       print('Verifying OTP for: $email, code: $otp');
//       final response = await dataSource.verifyOTP(email, otp);
//
//       if (response.success) {
//         print('OTP verified successfully');
//         return Right(
//           OTPEntity(success: response.success, message: response.message),
//         );
//       } else {
//         print('OTP verification failed: ${response.message}');
//         return Left(response.message);
//       }
//     } catch (e) {
//       print('OTP verification error: $e');
//       return Left(e.toString());
//     }
//   }
//
//   @override
//   Future<Either<String, OTPEntity>> setNewPassword(
//     String email,
//     String otp,
//     String newPassword,
//   ) async {
//     try {
//       print('🔄 Setting new password for: $email');
//       print('🔢 Using OTP: $otp');
//
//       final response = await dataSource.setNewPassword(email, otp, newPassword);
//
//       if (response.success) {
//         print('✅ Password reset successfully');
//         return Right(
//           OTPEntity(success: response.success, message: response.message),
//         );
//       } else {
//         print('❌ Password reset failed: ${response.message}');
//         return Left(response.message);
//       }
//     } catch (e) {
//       print('💥 Password reset error: $e');
//       return Left(e.toString());
//     }
//   }
// }
import 'package:dartz/dartz.dart';


import '../../../../domain/repositories/auth/otp_repository.dart';
import '../../../domain/entities/auth/otp.dart';
import '../../datasources/auth/otp_datasource.dart';


class OTPRepositoryImpl implements OTPRepository {
  final OTPDataSource dataSource;

  OTPRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, OTPEntity>> sendOTP(String email) async {
    try {
      print('Sending OTP to: $email');
      final response = await dataSource.sendOTP(email);
      if (response.success) {
        print('OTP sent successfully');
        return Right(OTPEntity(success: response.success, message: response.message));
      } else {
        print('OTP send failed: ${response.message}');
        return Left(response.message);
      }
    } catch (e) {
      print('OTP send error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, OTPEntity>> verifyOTP(String email, String otp) async {
    try {
      print('Verifying OTP for: $email, code: $otp');
      final response = await dataSource.verifyOTP(email, otp);

      if (response.success) {
        print('OTP verified successfully');
        return Right(OTPEntity(success: response.success, message: response.message));
      } else {
        print('OTP verification failed: ${response.message}');
        return Left(response.message);
      }
    } catch (e) {
      print('OTP verification error: $e');
      return Left(e.toString());
    }
  }
}