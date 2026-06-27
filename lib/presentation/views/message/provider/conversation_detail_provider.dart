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
  bool isAddingMembers = false;
  bool isUpdatingSilent = false;
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

  Future<bool> addMembers(
    String conversationId,
    List<String> userIds,
  ) async {
    if (conversationId.isEmpty || userIds.isEmpty) return false;

    isAddingMembers = true;
    error = null;
    notifyListeners();

    try {
      final res = await _dioClient.postHttp(
        ApiEndpoints.addConversationMembers(conversationId),
        {'member_ids': userIds},
      );

      if (res is ResponseModel) {
        error = res.message;
        return false;
      }
      if (res is Map && res['success'] == true) {
        error = null;
        return true;
      }
      error = res is Map
          ? (res['message']?.toString() ?? 'Failed to add members')
          : 'Failed to add members';
      return false;
    } catch (e) {
      error = e.toString();
      logger.e('addMembers error: $e');
      return false;
    } finally {
      isAddingMembers = false;
      notifyListeners();
    }
  }

  Future<bool> removeMember(String conversationId, String memberId) async {
    if (conversationId.isEmpty || memberId.isEmpty) return false;

    try {
      final res = await _dioClient.deleteHttp(
        ApiEndpoints.removeMember(conversationId, memberId),
      );

      if (res is Map && res['success'] == true) {
        await fetchMembers(conversationId);
        return true;
      }
      error = res is Map
          ? (res['message']?.toString() ?? 'Failed to remove member')
          : 'Failed to remove member';
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      logger.e('removeMember error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMemberRole(
    String conversationId,
    String memberId,
    String role,
  ) async {
    if (conversationId.isEmpty || memberId.isEmpty) return false;

    try {
      final res = await _dioClient.patchHttp(
        ApiEndpoints.updateMemberRole(conversationId, memberId),
        {'role': role},
      );

      if (res is Map && res['success'] == true) {
        await fetchMembers(conversationId);
        return true;
      }
      error = res is Map
          ? (res['message']?.toString() ?? 'Failed to update role')
          : 'Failed to update role';
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      logger.e('updateMemberRole error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> leaveGroup(String conversationId) async {
    if (conversationId.isEmpty) return false;

    try {
      final res = await _dioClient.deleteHttp(
        ApiEndpoints.leaveConversation(conversationId),
      );

      if (res is Map && res['success'] == true) {
        error = null;
        return true;
      }
      error = res is Map
          ? (res['message']?.toString() ?? 'Failed to leave group')
          : 'Failed to leave group';
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      logger.e('leaveGroup error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteConversation(String conversationId) async {
    if (conversationId.isEmpty) return false;

    try {
      final res = await _dioClient.deleteHttp(
        ApiEndpoints.deleteConversation(conversationId),
      );

      if (res is Map && res['success'] == true) {
        error = null;
        return true;
      }
      error = res is Map
          ? (res['message']?.toString() ?? 'Failed to delete conversation')
          : 'Failed to delete conversation';
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      logger.e('deleteConversation error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSilent({
    required String conversationId,
    required String mode,
    DateTime? untilAt,
  }) async {
    if (conversationId.isEmpty) return false;

    isUpdatingSilent = true;
    error = null;
    notifyListeners();

    try {
      final body = <String, dynamic>{'mode': mode};
      if (mode == 'until' && untilAt != null) {
        body['until_at'] = untilAt.toUtc().toIso8601String();
      }

      final res = await _dioClient.patchHttp(
        ApiEndpoints.conversationSilent(conversationId),
        body,
      );

      if (res is ResponseModel) {
        error = res.message;
        return false;
      }

      if (res is Map && res['success'] == true && res['data'] is Map) {
        final data = Map<String, dynamic>.from(res['data'] as Map);
        final isSilenced = data['is_silenced'] == true;
        final mutedUntil = data['muted_until']?.toString();
        final silentMode = data['mode']?.toString();

        if (detail != null) {
          if (!isSilenced) {
            detail = detail!.copyWith(
              isSilenced: false,
              clearMutedUntil: true,
            );
          } else if (silentMode == 'forever') {
            detail = detail!.copyWith(
              isSilenced: true,
              clearMutedUntil: true,
            );
          } else {
            detail = detail!.copyWith(
              isSilenced: true,
              mutedUntil: mutedUntil,
            );
          }
        } else {
          await fetchDetail(conversationId);
        }

        error = null;
        return true;
      }

      error = res is Map
          ? (res['message']?.toString() ?? 'Failed to update mute settings')
          : 'Failed to update mute settings';
      return false;
    } catch (e) {
      error = e.toString();
      logger.e('updateSilent error: $e');
      return false;
    } finally {
      isUpdatingSilent = false;
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
    isAddingMembers = false;
    isUpdatingSilent = false;
  }
}
