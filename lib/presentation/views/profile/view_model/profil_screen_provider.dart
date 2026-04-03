import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/presentation/views/profile/model/other_profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import '../../../../cors/network/api_response_model.dart';
import '../../../../cors/services/api_client.dart';
import '../model/profile_model.dart';

class ProfileScreenProvider extends ChangeNotifier {
  ProfileScreenProvider() {
    getProfile();
  }

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();

  bool _isLoading = false;
  String? _errorMessage;
  CheckMeModel? _profile;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  CheckMeModel? get profile => _profile;
  OtherProfileModel? _otherProfileModel;

  OtherProfileModel? get otherProfileModel => _otherProfileModel;

  /// ------------------- GET PROFILE API --------------------------------------
  Future<void> getProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.getProfile,
      );

      logger.i("API Success Status: ${response.success}");
      logger.i("API Message: ${response.message}");
      logger.d("Raw API Data: ${response.data}");

      if (response.success) {
        _profile = CheckMeModel.fromJson(response.data);

        logger.i("Profile Parsed Successfully");
        logger.d("User ID: ${_profile?.data?.id}");
        logger.d("User Email: ${_profile?.data?.email}");
      } else {
        _errorMessage = response.message;
        logger.e("API Returned Error: $_errorMessage");
      }
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      logger.e("Exception Occurred");
      logger.e(e);
      logger.e(stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOtherProfile(String userId) async {
    logger.i("========== PROFILE API START ==========");

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.getOtherProfile(userId),
      );

      logger.i("API Success Status: ${response.success}");
      logger.i("API Message: ${response.message}");
      logger.d("Raw API Data: ${response.data}");

      if (response.success) {
        _otherProfileModel = OtherProfileModel.fromJson(response.data);

        logger.i("Profile Parsed Successfully");
        logger.d("User ID: ${_otherProfileModel?.data?.id}");
        logger.d("User Email: ${_otherProfileModel?.data?.email}");
      } else {
        _errorMessage = response.message;
        logger.e("API Returned Error: $_errorMessage");
      }
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      logger.e("Exception Occurred");
      logger.e(e);
      logger.e(stackTrace);
    }

    _isLoading = false;
    notifyListeners();

    logger.i("========== PROFILE API END ==========");
  }

  /// ------------------ Edit Profile -----------------------------------------
  Future<bool> editProfile({
    required String name,
    required String phone,
    required String dob,
    required String goal,
    required String experienceLevel,
    String? imagePath,
  }) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.patchMultipart(
        ApiEndpoints.editProfile,
        fields: {
          "name": name,
          "phone_number": phone,
          "date_of_birth": dob,
          'experience_level': experienceLevel,
          "ActingGoals": goal,
        },
        fileField: "image",
        filePath: imagePath ?? "",
      );

      if (response.success) {
        _profile = CheckMeModel.fromJson(response.data);
        logger.i("Profile Updated Successfully");
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        logger.e("Edit Profile Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
