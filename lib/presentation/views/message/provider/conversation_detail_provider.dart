import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/message/model/conversation_detail_model.dart';
import 'package:flutter/foundation.dart';

class ConversationDetailProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  ConversationDetail? detail;
  List<GroupMember> members = const [];
  int membersTotal = 0;
  bool isLoadingDetail = false;
  bool isLoadingMembers = false;
  String? error;

  Future<void> fetchDetail(String conversationId) async {
    if (conversationId.isEmpty) return;
    isLoadingDetail = true;
    error = null;
    notifyListeners();

    try {
      final res = await _dioClient.getHttp(
        ApiEndpoints.conversationDetail(conversationId),
      );

      if (res is ResponseModel) {
        error = res.message;
      } else if (res is Map && res['success'] == true && res['data'] is Map) {
        detail = ConversationDetail.fromJson(
          Map<String, dynamic>.from(res['data'] as Map),
        );
        error = null;
      } else {
        error = res is Map
            ? (res['message']?.toString() ?? 'Failed to load conversation')
            : 'Failed to load conversation';
      }
    } catch (e) {
      error = e.toString();
      logger.e('fetchDetail error: $e');
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> fetchMembers(String conversationId, {String? role}) async {
    if (conversationId.isEmpty) return;
    isLoadingMembers = true;
    error = null;
    notifyListeners();

    try {
      final res = await _dioClient.getHttp(
        ApiEndpoints.conversationMembers(conversationId, role: role),
      );

      if (res is ResponseModel) {
        error = res.message;
      } else if (res is Map && res['success'] == true) {
        final model = GroupMembersResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        members = model.members;
        membersTotal = model.total > 0 ? model.total : model.members.length;
        error = null;
      } else {
        error = res is Map
            ? (res['message']?.toString() ?? 'Failed to load members')
            : 'Failed to load members';
      }
    } catch (e) {
      error = e.toString();
      logger.e('fetchMembers error: $e');
    } finally {
      isLoadingMembers = false;
      notifyListeners();
    }
  }

  void reset() {
    detail = null;
    members = const [];
    membersTotal = 0;
    error = null;
    isLoadingDetail = false;
    isLoadingMembers = false;
  }
}
