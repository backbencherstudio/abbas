
import '../domain/UserEntity.dart';
import '../domain/signUpRepository.dart';
import 'SignUpRemoteDataSource.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpRemoteDatasource signUpRemoteDatasource;

  SignUpRepositoryImpl({required this.signUpRemoteDatasource});

  @override
  Future<SignupResult> signUp(
    String name,
    String email,
    String password,
  ) async {
    final res = await signUpRemoteDatasource.signUp(
      name,
      email,
      password,
    );
    return SignupResult(message: res['message']);
  }
}
