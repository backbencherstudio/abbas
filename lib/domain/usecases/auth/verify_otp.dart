import 'package:dartz/dartz.dart';

import '../../entities/auth/otp.dart';
import '../../repositories/auth/otp_repository.dart';



class VerifyOTPUseCase {
  final OTPRepository repository;

  VerifyOTPUseCase({required this.repository});

  Future<Either<String, OTPEntity>> execute(String email, String otp) async {
    return await repository.verifyOTP(email, otp);
  }
}