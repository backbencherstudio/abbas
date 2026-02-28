import 'package:abbas/cors/constants/api_endpoints.dart';
import '../../../../../cors/services/api_client.dart';

class SignUpRemoteDatasource {
  final ApiClient apiClient;
  SignUpRemoteDatasource(this.apiClient);

  Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
  ) async {
    // Added async
    final response = await apiClient.post(
      // Added await
      ApiEndpoints.register,
      headers: {"Content-Type": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );

    // Cast the dynamic response to the expected Map type
    return response as Map<String, dynamic>;
  }
}
