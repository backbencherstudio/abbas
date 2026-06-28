import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/message/model/call_model.dart';

class RtcService {
  final DioClient _dioClient;

  RtcService({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<CallSession?> getState(String conversationId) async {
    final res = await _dioClient.getHttp(
      ApiEndpoints.getCallState(conversationId),
    );
    return _parseSession(res);
  }

  Future<CallSession> startCall(
    String conversationId,
    CallKind kind,
  ) async {
    final res = await _dioClient.postHttp(
      ApiEndpoints.startCall(conversationId),
      {'kind': kind.apiValue},
    );
    final session = _parseSession(res, required: true);
    return session!;
  }

  Future<CallSession> joinCall(String conversationId) async {
    final res = await _dioClient.postHttp(
      ApiEndpoints.joinCall(conversationId),
      null,
    );
    final session = _parseSession(res, required: true);
    return session!;
  }

  Future<CallSession> refreshToken(String conversationId) async {
    final res = await _dioClient.postHttp(
      ApiEndpoints.getToken(conversationId),
      null,
    );
    final session = _parseSession(res, required: true);
    return session!;
  }

  Future<void> declineCall(String conversationId) async {
    await _postOrThrow(ApiEndpoints.declineCall(conversationId));
  }

  Future<void> leaveCall(String conversationId) async {
    await _postOrThrow(ApiEndpoints.leaveCall(conversationId));
  }

  Future<void> endCall(String conversationId) async {
    await _postOrThrow(ApiEndpoints.endCall(conversationId));
  }

  Future<CallParticipant> updateMedia(
    String conversationId, {
    bool? camera,
    bool? microphone,
    bool? isScreenSharing,
  }) async {
    final body = <String, dynamic>{};
    if (camera != null) body['camera'] = camera;
    if (microphone != null) body['microphone'] = microphone;
    if (isScreenSharing != null) body['is_screen_sharing'] = isScreenSharing;

    final res = await _dioClient.patchHttp(
      ApiEndpoints.updateCallParticipant(conversationId),
      body,
    );

    if (res is Map && res['success'] == true && res['data'] is Map) {
      final data = Map<String, dynamic>.from(res['data'] as Map);
      final participant = data['participant'] ?? data;
      if (participant is Map) {
        return CallParticipant.fromJson(
          Map<String, dynamic>.from(participant),
        );
      }
    }
    throw Exception(_errorMessage(res, 'Failed to update media state'));
  }

  Future<void> _postOrThrow(String path) async {
    final res = await _dioClient.postHttp(path, null);
    if (res is Map && res['success'] == true) return;
    throw Exception(_errorMessage(res, 'Request failed'));
  }

  CallSession? _parseSession(dynamic res, {bool required = false}) {
    if (res is ResponseModel) {
      if (required) throw Exception(res.message ?? 'Request failed');
      return null;
    }
    if (res is Map && res['success'] == true) {
      final data = res['data'];
      if (data == null) return null;
      if (data is Map) {
        return CallSession.fromJson(Map<String, dynamic>.from(data));
      }
    }
    if (required) {
      throw Exception(_errorMessage(res, 'Request failed'));
    }
    return null;
  }

  String _errorMessage(dynamic res, String fallback) {
    if (res is Map) return res['message']?.toString() ?? fallback;
    return fallback;
  }
}
