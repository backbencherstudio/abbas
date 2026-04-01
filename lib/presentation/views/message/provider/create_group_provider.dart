import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_response_model.dart';
import 'package:abbas/cors/services/api_client.dart';
import 'package:abbas/presentation/views/message/model/create_group_model.dart';
import 'package:abbas/presentation/views/message/model/suggest_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class CreateGroupProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();

  bool _isLoading = false;
  String? _errorMessage;
  SuggestModel? _suggestModel;
  CreateGroupModel? _createGroupModel;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  SuggestModel? get suggestModel => _suggestModel;
  CreateGroupModel? get createGroupModel => _createGroupModel;

  // Main Search Function
  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      _suggestModel = null;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.searchUser(query.trim()),
      );
      debugPrint("========= response ${response.data}");
      if (response.success && response.data != null) {
        _suggestModel = SuggestModel.fromJson(response.data);
        _errorMessage = null;
      } else {
        _suggestModel = null;
        _errorMessage = response.message ?? "Something went wrong";
      }
    } catch (error) {
      _suggestModel = null;
      _errorMessage = "Failed to fetch suggestions";
      logger.e("Search Users Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createGroup({
    required Set<String> selectedUserIds,
    String? groupTitle,
  }) async {
    if (selectedUserIds.isEmpty) {
      _errorMessage = "Please select at least one member";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> requestBody = {
        "title": groupTitle?.trim().isNotEmpty == true ? groupTitle!.trim() : "New Group",
        "memberIds": selectedUserIds.toList(),   // ← This is what backend expects
      };

      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.createGroupChat,
        body: requestBody,
      );

      if (response.success && response.data != null) {
        _createGroupModel = CreateGroupModel.fromJson(response.data);
        debugPrint("✅ Group Created Successfully: ${_createGroupModel?.id}");
      } else {
        _errorMessage = response.message ?? "Failed to create group";
        debugPrint(" Group creation failed: ${response.message}");
      }
    } catch (error) {
      _errorMessage = "Something went wrong while creating group";
      logger.e("Create Group Error: $error");
      debugPrint("Create Group Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void clearSearch() {
    _suggestModel = null;
    _errorMessage = null;
    notifyListeners();
  }
}
