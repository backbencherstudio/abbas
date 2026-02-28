// import 'package:cinact/cors/constants/api_endpoints.dart';
// import 'package:dio/dio.dart';
//
// import '../../../cors/services/api_services.dart';
// import '../../models/auth/otp_response_model.dart';
//
// abstract class OTPDataSource {
//   Future<OTPResponseModel> sendOTP(String email);
//
//   Future<OTPResponseModel> verifyOTP(String email, String otp);
//
//   Future<OTPResponseModel> setNewPassword(
//     String email,
//     String otp,
//     String newPassword,
//   ); // Add this method
// }
//
// class OTPDataSourceImpl implements OTPDataSource {
//   final ApiService apiService;
//
//   OTPDataSourceImpl({required this.apiService});
//
//   @override
//   Future<OTPResponseModel> sendOTP(String email) async {
//     try {
//       final response = await apiService.post(
//         ApiEndpoints.forgetPasswordEmail,
//         data: {'email': email},
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//           validateStatus: (status) => status! < 500,
//         ),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return OTPResponseModel.fromJson(response.data);
//       } else {
//         final errorData = response.data ?? {};
//         final errorMessage = errorData['message'] ?? 'Failed to send OTP';
//         throw Exception(errorMessage);
//       }
//     } on DioException catch (e) {
//       if (e.response != null) {
//         final errorData = e.response!.data ?? {};
//         final errorMessage =
//             errorData['message'] ??
//             e.response!.statusMessage ??
//             'Failed to send OTP';
//         throw Exception(errorMessage);
//       } else {
//         throw Exception('Network error: ${e.message}');
//       }
//     } catch (e) {
//       throw Exception('Failed to send OTP: $e');
//     }
//   }
//
//   @override
//   Future<OTPResponseModel> verifyOTP(String email, String otp) async {
//     try {
//       final response = await apiService.post(
//         ApiEndpoints.verifyEmail,
//         data: {'email': email, 'otp': otp},
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//           validateStatus: (status) => status! < 500,
//         ),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return OTPResponseModel.fromJson(response.data);
//       } else {
//         final errorData = response.data ?? {};
//         final errorMessage = errorData['message'] ?? 'Failed to verify OTP';
//         throw Exception(errorMessage);
//       }
//     } on DioException catch (e) {
//       if (e.response != null) {
//         final errorData = e.response!.data ?? {};
//         final errorMessage =
//             errorData['message'] ??
//             e.response!.statusMessage ??
//             'Failed to verify OTP';
//         throw Exception(errorMessage);
//       } else {
//         throw Exception('Network error: ${e.message}');
//       }
//     } catch (e) {
//       throw Exception('Failed to verify OTP: $e');
//     }
//   }
//
//   @override
//   Future<OTPResponseModel> setNewPassword(
//     String email,
//     String otp,
//     String newPassword,
//   ) async {
//     try {
//       final response = await apiService.post(
//         ApiEndpoints.resetPassword,
//         data: {'email': email, 'otp': otp, 'new_password': newPassword},
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//           validateStatus: (status) => status! < 500,
//         ),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return OTPResponseModel.fromJson(response.data);
//       } else {
//         final errorData = response.data ?? {};
//         String errorMessage;
//
//         switch (response.statusCode) {
//           case 401:
//             errorMessage =
//                 errorData['message'] ??
//                 'OTP verification failed or expired. Please request a new OTP.';
//             break;
//           case 400:
//             errorMessage =
//                 errorData['message'] ??
//                 'Invalid request. Please check your input.';
//             break;
//           case 404:
//             errorMessage = errorData['message'] ?? 'User not found.';
//             break;
//           default:
//             errorMessage =
//                 errorData['message'] ??
//                 'Failed to reset password. Please try again.';
//         }
//         throw Exception(errorMessage);
//       }
//     } on DioException catch (e) {
//       if (e.response != null) {
//         final errorData = e.response!.data ?? {};
//         final errorMessage =
//             errorData['message'] ??
//             e.response!.statusMessage ??
//             'Failed to reset password. Please try again.';
//         throw Exception(errorMessage);
//       } else {
//         throw Exception('Network error: ${e.message}');
//       }
//     } catch (e) {
//       throw Exception('Failed to reset password: $e');
//     }
//   }
// }

import 'package:dio/dio.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/api_services.dart';
import '../../models/auth/otp_response_model.dart';

abstract class OTPDataSource {
  Future<OTPResponseModel> sendOTP(String email);
  Future<OTPResponseModel> verifyOTP(String email, String otp);
}

class OTPDataSourceImpl implements OTPDataSource {
  final ApiService apiService;

  OTPDataSourceImpl({required this.apiService});

  @override
  Future<OTPResponseModel> sendOTP(String email) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.forgetPasswordEmail,
        data: {'email': email},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OTPResponseModel.fromJson(response.data);
      } else {
        final errorData = response.data ?? {};
        final errorMessage = errorData['message'] ?? 'Failed to send OTP';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data ?? {};
        final errorMessage = errorData['message'] ?? e.response!.statusMessage ?? 'Failed to send OTP';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  @override
  Future<OTPResponseModel> verifyOTP(String email, String otp) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.verifyEmail,
        data: {'email': email, 'otp': otp},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OTPResponseModel.fromJson(response.data);
      } else {
        final errorData = response.data ?? {};
        final errorMessage = errorData['message'] ?? 'Failed to verify OTP';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data ?? {};
        final errorMessage = errorData['message'] ?? e.response!.statusMessage ?? 'Failed to verify OTP';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
}