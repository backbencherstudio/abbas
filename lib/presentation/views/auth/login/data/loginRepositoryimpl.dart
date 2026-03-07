import '../domain/loginEntity.dart';
import '../domain/loginRepository.dart';
import 'loginRemoteDataSources.dart';


class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImpl(this.loginRemoteDataSource);

  @override
  Future<LoginEntity> login({
    required String email,
    required String password,
  }) async {
    final loginModel = await loginRemoteDataSource.login(email, password);

    if (loginModel.authorization == null) {
      throw Exception('Authorization data missing from login response');
    }

    return LoginEntity(
      accessToken: loginModel.authorization!.accessToken ?? '',
      refreshToken: loginModel.authorization!.refreshToken ?? '',
    );
  }
}