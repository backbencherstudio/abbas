import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/network/api_response_model.dart';
import '../../../../cors/services/api_client.dart';
import '../../../../cors/services/live_kit_service.dart';

class CallProvider extends ChangeNotifier {
  CallProvider() {
    checkHealth();
  }

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final LiveKitService liveKitService = LiveKitService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isInCall = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;

  String? _currentCallId;
  String? _currentRoomName;
  String? _liveKitUrl;
  String? _currentCallKind;

  // Incoming Call State
  Map<String, dynamic>? _incomingCallData;
  bool get hasIncomingCall => _incomingCallData != null;
  Map<String, dynamic>? get incomingCallData => _incomingCallData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInCall => _isInCall;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;

  String? get currentCallId => _currentCallId;
  String? get currentRoomName => _currentRoomName;
  String? get currentCallKind => _currentCallKind;

  // ==================== Socket Listener Setup ====================
  void setupSocketListeners(dynamic socket) {
    socket?.on('call:incoming', (data) {
      logger.i("📲 Incoming call received: $data");
      _incomingCallData = data;
      notifyListeners();

      // Optional: Show notification or dialog automatically
      // showIncomingCallDialog(data);
    });

    socket?.on('call:ended', (data) {
      logger.i("📴 Call ended by other side");
      _incomingCallData = null;
      if (_isInCall) leaveCall(data['conversationId'] ?? '');
      notifyListeners();
    });
  }

  // Clear incoming call
  void clearIncomingCall() {
    _incomingCallData = null;
    notifyListeners();
  }

  // Accept Incoming Call
  Future<bool> acceptIncomingCall() async {
    if (_incomingCallData == null) return false;

    final conversationId = _incomingCallData!['conversationId'];
    if (conversationId == null) return false;

    clearIncomingCall();
    return await joinCall(conversationId);
  }

  // Reject Incoming Call
  void rejectIncomingCall() {
    // TODO: Send reject signal to backend if needed
    clearIncomingCall();
    logger.i("❌ Incoming call rejected");
  }

  // ==================== Existing Methods (সংক্ষেপে) ====================
  Future<bool> startCall(String conversationId, {String kind = "VIDEO"}) async {
    _resetCallState();
    _isLoading = true;
    _currentCallKind = kind.toUpperCase();
    notifyListeners();

    try {
      if (liveKitService.isConnected) await liveKitService.disconnect();

      final startResponse = await _apiClient.post(
        ApiEndpoints.startCall(conversationId),
        body: {"kind": kind},
      );

      if (!startResponse.success) {
        _errorMessage = startResponse.message ?? "Failed to start call";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentCallId =
          startResponse.data?['callId'] ??
          startResponse.data?['data']?['callId'];

      final tokenSuccess = await _getLiveKitToken(conversationId, kind);
      if (tokenSuccess) {
        _isInCall = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _getLiveKitToken(String conversationId, String kind) async {
    try {
      final tokenResponse = await _apiClient.post(
        ApiEndpoints.getToken(conversationId),
      );

      if (!tokenResponse.success || tokenResponse.data == null) {
        _errorMessage = tokenResponse.message ?? "Failed to get token";
        return false;
      }

      final tokenData = tokenResponse.data!['data'] ?? tokenResponse.data;
      final token = tokenData['token'];
      final roomName = tokenData['roomName'];
      final url = tokenData['url'];

      if (token == null || roomName == null || url == null) {
        _errorMessage = "Invalid token response";
        return false;
      }

      _currentRoomName = roomName;
      _liveKitUrl = url;

      return await _connectToLiveKit(token, url, roomName, kind);
    } catch (e) {
      _errorMessage = "Token request failed";
      logger.e("Token error: $e");
      return false;
    }
  }

  Future<bool> _connectToLiveKit(
    String token,
    String url,
    String roomName,
    String kind,
  ) async {
    try {
      final bool audioOnly = kind.toUpperCase() == "AUDIO";
      await liveKitService.connectToRoom(
        url: url,
        token: token,
        roomName: roomName,
        audioOnly: audioOnly,
      );
      return true;
    } catch (e) {
      _errorMessage = "Failed to connect to LiveKit";
      logger.e("LiveKit connect error: $e");
      return false;
    }
  }

  Future<bool> joinCall(String conversationId) async {
    _resetCallState();
    _isLoading = true;
    notifyListeners();

    try {
      if (liveKitService.isConnected) await liveKitService.disconnect();

      final response = await _apiClient.post(
        ApiEndpoints.joinCall(conversationId),
      );
      if (!response.success) {
        _errorMessage = response.message ?? "Failed to join call";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      return await _getLiveKitToken(conversationId, "VIDEO");
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> leaveCall(String conversationId) async {
    try {
      await _apiClient.post(ApiEndpoints.leaveCall(conversationId));
    } catch (e) {
      logger.e("Leave API error: $e");
    } finally {
      await liveKitService.disconnect();
      _resetCallState();
    }
  }

  Future<void> endCall(String conversationId) async {
    try {
      await _apiClient.post(ApiEndpoints.endCall(conversationId));
    } catch (e) {
      logger.e("End call error: $e");
    } finally {
      await liveKitService.disconnect();
      _resetCallState();
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      liveKitService.disableAudio();
    } else {
      liveKitService.enableAudio();
    }
    notifyListeners();
  }

  void toggleVideo() {
    _isVideoEnabled = !_isVideoEnabled;
    if (_isVideoEnabled) {
      liveKitService.enableVideo();
    } else {
      liveKitService.disableVideo();
    }
    notifyListeners();
  }

  Future<void> switchCamera() async {
    try {
      await liveKitService.switchCamera();
    } catch (e) {
      logger.e("Switch camera error: $e");
      _errorMessage = "Failed to switch camera";
      notifyListeners();
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.rtcHealth);
      return response.success;
    } catch (e) {
      logger.e("Health check failed: $e");
      return false;
    }
  }

  void _resetCallState() {
    _isLoading = false;
    _isInCall = false;
    _isMuted = false;
    _isVideoEnabled = true;
    _errorMessage = null;
    _currentCallId = null;
    _currentRoomName = null;
    _liveKitUrl = null;
    _currentCallKind = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
