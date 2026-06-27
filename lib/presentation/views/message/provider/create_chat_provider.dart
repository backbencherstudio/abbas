import 'dart:async';
import 'dart:convert';

import 'package:abbas/presentation/views/message/model/all_conversation_model.dart';
import 'package:abbas/presentation/views/message/model/create_conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/token_storage.dart';

class CreateChatProvider extends ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();
  final Logger logger = Logger();

  bool _isLoading = false;
  String? _errorMessage;
  String? _creatingParticipantId;
  bool get isLoading => _isLoading;
  String? get creatingParticipantId => _creatingParticipantId;
  String? get errorMessage => _errorMessage;

  CreateConversationModel? _createConversationModel;
  CreateConversationModel? get createConversationModel =>
      _createConversationModel;

  List<AllConversationModel> _allConversationModel = [];
  List<AllConversationModel> get allConversationModel => _allConversationModel;

  String selectedFilter = 'All';

  CreateChatProvider();

  void toggleFilter(String value) {
    selectedFilter = value;
    notifyListeners();
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// `POST /api/conversations` — create or return existing DM.
  Future<CreateConversationModel?> createConversation(String participantId) async {
    _errorMessage = null;
    _isLoading = true;
    _creatingParticipantId = participantId;
    notifyListeners();

    try {
      final headers = await _buildHeaders();
      final response = await http.post(
        Uri.parse(ApiEndpoints.createConversation),
        headers: headers,
        body: jsonEncode({
          'type': 'DM',
          'participant_id': participantId,
        }),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (json['success'] == true && json['data'] is Map) {
          _createConversationModel = CreateConversationModel.fromApiResponse(
            Map<String, dynamic>.from(json['data'] as Map),
          );
          logger.i(
            'Create conversation: ${json['message']} — id=${_createConversationModel!.id}',
          );
          return _createConversationModel;
        }
      }

      _errorMessage =
          json['message']?.toString() ?? 'Failed to create conversation';
      logger.e('Create conversation failed: ${response.statusCode} — $_errorMessage');
      return null;
    } catch (error) {
      _errorMessage = error.toString();
      logger.e('Create conversation error: $error');
      return null;
    } finally {
      _isLoading = false;
      _creatingParticipantId = null;
      notifyListeners();
    }
  }

  /// Fetch all conversations (DM + Group).
  /// The /conversations API returns a plain JSON array — no {success, data} wrapper.
  Future<bool> getAllConversation() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final headers = await _buildHeaders();
      final response = await http.get(
        Uri.parse('${ApiEndpoints.allConversationList}?take=50&skip=0'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body is List) {
          _allConversationModel = body
              .map((e) =>
                  AllConversationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (body is Map && body['data'] is List) {
          // Fallback if API ever wraps in {data: [...]}
          _allConversationModel = (body['data'] as List)
              .map((e) =>
                  AllConversationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return true;
      } else {
        final json = jsonDecode(response.body);
        _errorMessage =
            json['message']?.toString() ?? 'Failed to load conversations';
        logger.e("Get conversations failed: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Get all conversation error: $error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
