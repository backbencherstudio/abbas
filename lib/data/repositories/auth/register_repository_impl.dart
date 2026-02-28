import '../../../domain/entities/auth/register.dart';
import '../../../domain/repositories/auth/register_repository.dart';
import '../../datasources/auth/register_datasource.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource registerDataSource;

  RegisterRepositoryImpl({required this.registerDataSource});

  @override
  Future<Register> register(String email, String password) async {
    try {
      final response = await registerDataSource.register(email, password);

      return Register(
        success: response.success ?? false,
        message: response.message ?? '',
      );
    } catch (e) {
      // Re-throw the exception with proper context
      if (e.toString().contains('409') ||
          e.toString().toLowerCase().contains('email already')) {
        throw Exception(
          'Registration failed: ${e.toString().replaceFirst('Exception: ', '')}',
        );
      }
      rethrow;
    }
  }
}
