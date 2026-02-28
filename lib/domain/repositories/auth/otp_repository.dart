import 'package:dartz/dartz.dart';

import '../../entities/auth/otp.dart';

abstract class OTPRepository {
  Future<Either<String, OTPEntity>> sendOTP(String email);
  Future<Either<String, OTPEntity>> verifyOTP(String email, String otp);

}

