import 'dart:async';

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/message/model/create_group_model.dart';
import 'package:abbas/presentation/views/message/model/suggest_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CreateGroupProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();
  Timer? _searchDebounce;

  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;
  SuggestModel? _suggestModel;
  CreateGroupModel? _createGroupModel;

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  SuggestModel? get suggestModel => _suggestModel;
  CreateGroupModel? get createGroupModel => _createGroupModel;
  List<Items> get users => _suggestModel?.items ?? const [];

  /// Initial suggested users (`search` empty).
  Future<void> loadSuggestedUsers() async {
    await _fetchDiscover(search: '');
  }

  void searchUsers(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _fetchDiscover(search: query.trim());
    });
  }

  Future<void> _fetchDiscover({required String search}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _dioClient.getHttp(
        ApiEndpoints.usersDiscover(search: search, limit: 20),
      );

      if (res is ResponseModel) {
        _errorMessage = res.message;
        if (search.isEmpty) _suggestModel = null;
      } else if (res is Map && res['success'] == true) {
        _suggestModel = SuggestModel.fromDiscoverResponse(
          Map<String, dynamic>.from(res),
        );
        _errorMessage = null;
      } else {
        _errorMessage = res is Map
            ? (res['message']?.toString() ?? 'Failed to load users')
            : 'Failed to load users';
        if (search.isEmpty) _suggestModel = null;
      }
    } catch (e) {
      _errorMessage = 'Failed to load users';
      logger.e('Discover users error: $e');
      if (search.isEmpty) _suggestModel = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// `POST /api/conversations` multipart — type GROUP (no avatar unless added later).
  Future<bool> createGroup({
    required Set<String> selectedUserIds,
    required String groupTitle,
  }) async {
    if (selectedUserIds.isEmpty) {
      _errorMessage = 'Please select at least one member';
      notifyListeners();
      return false;
    }

    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final formData = FormData();
      formData.fields.add(const MapEntry('type', 'GROUP'));
      formData.fields.add(MapEntry(
        'title',
        groupTitle.trim().isNotEmpty ? groupTitle.trim() : 'New Group',
      ));
      for (final id in selectedUserIds) {
        formData.fields.add(MapEntry('participant_ids', id));
      }

      final res = await _dioClient.postMultipart(
        ApiEndpoints.createConversation,
        formData,
      );

      if (res is ResponseModel) {
        _errorMessage = res.message;
        return false;
      }

      if (res is Map && res['success'] == true && res['data'] is Map) {
        _createGroupModel = CreateGroupModel.fromApiResponse(
          Map<String, dynamic>.from(res['data'] as Map),
          includeAvatar: false,
        );
        logger.i('Group created: ${res['message']} — id=${_createGroupModel?.id}');
        return true;
      }

      _errorMessage = res is Map
          ? (res['message']?.toString() ?? 'Failed to create group')
          : 'Failed to create group';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      logger.e('Create group error: $e');
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    loadSuggestedUsers();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
