import '../../../../../domain/repositories/auth/login_repository.dart';
import '../domain/loginEntity.dart';
import 'loginRemoteDataSources.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImpl(this.loginRemoteDataSource);

  @override
  Future<LoginEntity> login(String email, String password) async {
    // Call the remote data source
    final loginModel = await loginRemoteDataSource.login(email, password);

    if (loginModel.authorization == null) {
      throw Exception('Authorization data missing from login response');
    }

    // Map LoginModel to LoginEntity
    return LoginEntity(
      accessToken: loginModel.authorization!.accessToken ?? '',
      refreshToken: loginModel.authorization!.refreshToken ?? '',
    );
  }
}