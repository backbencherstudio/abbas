import 'package:dartz/dartz.dart';

import '../../entities/auth/otp.dart';
import '../../repositories/auth/otp_repository.dart';



class SendOTPUseCase {
  final OTPRepository repository;

  SendOTPUseCase({required this.repository});

  Future<Either<String, OTPEntity>> execute(String email) async {
    return await repository.sendOTP(email);
  }
}