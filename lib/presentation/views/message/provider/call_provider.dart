import 'dart:async';

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/services/api_client.dart';
import 'package:abbas/cors/services/live_kit_service.dart';
import 'package:abbas/cors/services/socket_call.dart';
import 'package:abbas/cors/services/token_storage.dart';
import 'package:abbas/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class CallProvider extends ChangeNotifier {
  CallProvider() {
    _init();
  }

  final ApiClient _apiClient = ApiClient();
  final LiveKitService liveKitService = LiveKitService();
  final SocketCall _socketService = SocketCall();
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  bool _isLoading = false;
  String? _errorMessage;
  bool _isInCall = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _incomingScreenOpen = false;

  String? _currentConversationId;
  String? _currentRoomName;
  String? _currentCallKind;

  Map<String, dynamic>? _incomingCallData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInCall => _isInCall;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get hasIncomingCall => _incomingCallData != null;
  Map<String, dynamic>? get incomingCallData => _incomingCallData;
  String? get currentCallKind => _currentCallKind;

  Future<void> _init() async {
    _wireSocketCallbacks();
    await _ensureSocketConnected();
  }

  Future<void> _ensureSocketConnected() async {
    try {
      final token = await TokenStorage().getToken();
      if (token != null && token.isNotEmpty && !_socketService.isConnected) {
        _socketService.connect(token);
      }
    } catch (e) {
      logger.e('Socket auto connect failed: $e');
    }
  }

  void _wireSocketCallbacks() {
    _socketService.onIncomingCall = _handleIncomingCall;
    _socketService.onCallEnded = _handleCallEnded;
  }

  Future<void> _handleIncomingCall(Map<String, dynamic> data) async {
    logger.i('Incoming call => $data');

    final conversationId = _pick(data, const [
      'conversationId',
      'conversation_id',
    ]);

    if (conversationId.isEmpty) return;

    if (_isInCall || _incomingScreenOpen) {
      logger.w('Ignoring incoming call because user is busy');
      return;
    }

    final callerName = _pick(data, const [
      'fromName',
      'callerName',
      'name',
      'senderName',
      'userName',
    ]);

    final callerAvatar = _pick(data, const [
      'fromAvatar',
      'callerAvatar',
      'avatarUrl',
      'avatar',
      'senderAvatar',
    ]);

    final fromUserId = _pick(data, const [
      'fromUserId',
      'from_user_id',
      'userId',
      'senderId',
    ]);

    final kind = _pick(data, const ['kind', 'callKind']).toUpperCase();
    final at = _pick(data, const ['at', 'createdAt']);

    _incomingCallData = {
      'conversationId': conversationId,
      'fromUserId': fromUserId,
      'fromName': callerName.isEmpty ? 'Unknown Caller' : callerName,
      'fromAvatar': callerAvatar,
      'kind': kind.isEmpty ? 'VIDEO' : kind,
      'at': at,
    };

    notifyListeners();
    HapticFeedback.heavyImpact();
    await _openIncomingCallScreen();
  }

  Future<void> _openIncomingCallScreen() async {
    final context = navigatorKey.currentContext;
    if (context == null || _incomingCallData == null) return;

    _incomingScreenOpen = true;

    await Navigator.pushNamed(
      context,
      RouteNames.incomingCallScreen,
      arguments: {
        'conversationId': _incomingCallData!['conversationId'],
        'callerName': _incomingCallData!['fromName'],
        'callerAvatar': _incomingCallData!['fromAvatar'],
        'callKind': _incomingCallData!['kind'],
      },
    );

    _incomingScreenOpen = false;
  }

  Future<bool> startCall(
      String conversationId, {
        String kind = 'VIDEO',
      }) async {
    await _ensureSocketConnected();

    _isLoading = true;
    _errorMessage = null;
    _currentConversationId = conversationId;
    _currentCallKind = kind.trim().toUpperCase();
    notifyListeners();

    try {
      if (liveKitService.isConnected) {
        await liveKitService.disconnect();
      }

      final response = await _apiClient.post(
        ApiEndpoints.startCall(conversationId),
        body: {'kind': _currentCallKind},
      );

      if (!response.success) {
        _errorMessage = response.message ?? 'Failed to start call';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final connected = await _fetchTokenAndConnect(
        conversationId: conversationId,
        kind: _currentCallKind!,
      );

      _isLoading = false;
      _isInCall = connected;
      notifyListeners();
      return connected;
    } catch (e) {
      logger.e('startCall error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinCall(
      String conversationId, {
        String kind = 'VIDEO',
      }) async {
    await _ensureSocketConnected();

    _isLoading = true;
    _errorMessage = null;
    _currentConversationId = conversationId;
    _currentCallKind = kind.trim().toUpperCase();
    notifyListeners();

    try {
      if (liveKitService.isConnected) {
        await liveKitService.disconnect();
      }

      final joinResponse = await _apiClient.post(
        ApiEndpoints.joinCall(conversationId),
      );

      if (!joinResponse.success) {
        _errorMessage = joinResponse.message ?? 'Failed to join call';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final connected = await _fetchTokenAndConnect(
        conversationId: conversationId,
        kind: _currentCallKind!,
      );

      _isLoading = false;
      _isInCall = connected;
      notifyListeners();
      return connected;
    } catch (e) {
      logger.e('joinCall error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _fetchTokenAndConnect({
    required String conversationId,
    required String kind,
  }) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.getToken(conversationId));

      if (!response.success || response.data == null) {
        _errorMessage = response.message ?? 'Failed to get LiveKit token';
        return false;
      }

      final data = response.data!['data'] ?? response.data!;
      final token = (data['token'] ?? '').toString();
      final roomName = (data['roomName'] ?? '').toString();
      final url = (data['url'] ?? '').toString();

      if (token.isEmpty || roomName.isEmpty || url.isEmpty) {
        _errorMessage = 'Invalid LiveKit token response';
        return false;
      }

      _currentRoomName = roomName;

      await liveKitService.connectToRoom(
        url: url,
        token: token,
        roomName: roomName,
        audioOnly: kind.toUpperCase() == 'AUDIO',
      );

      return true;
    } catch (e) {
      logger.e('LiveKit connect error: $e');
      _errorMessage = 'Failed to connect to LiveKit';
      return false;
    }
  }

  Future<bool> acceptIncomingCall() async {
    final data = _incomingCallData;
    if (data == null) return false;

    final conversationId = (data['conversationId'] ?? '').toString();
    final kind = (data['kind'] ?? 'VIDEO').toString().toUpperCase();
    final callerName = (data['fromName'] ?? 'Unknown Caller').toString();
    final callerAvatar = (data['fromAvatar'] ?? '').toString();

    if (conversationId.isEmpty) return false;

    final success = await joinCall(conversationId, kind: kind);
    if (!success) return false;

    _incomingCallData = null;
    notifyListeners();

    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.pushReplacementNamed(
        context,
        kind == 'AUDIO'
            ? RouteNames.audioCallScreen
            : RouteNames.videoCallScreen,
        arguments: {
          'conversationId': conversationId,
          'callKind': kind,
          'autoStart': false,
          'callerName': callerName,
          'callerAvatar': callerAvatar,
        },
      );
    }

    return true;
  }

  Future<void> rejectIncomingCall() async {
    final data = _incomingCallData;
    _incomingCallData = null;
    notifyListeners();

    if (data == null) return;

    final conversationId = (data['conversationId'] ?? '').toString();
    if (conversationId.isEmpty) return;

    try {
      await _apiClient.post(ApiEndpoints.endCall(conversationId));
    } catch (e) {
      logger.e('Reject call error: $e');
    }
  }

  Future<void> leaveCall(String conversationId) async {
    try {
      await _apiClient.post(ApiEndpoints.leaveCall(conversationId));
    } catch (e) {
      logger.e('Leave call error: $e');
    } finally {
      await _cleanupAfterCall();
    }
  }

  Future<void> endCall(String conversationId) async {
    try {
      await _apiClient.post(ApiEndpoints.endCall(conversationId));
    } catch (e) {
      logger.e('End call error: $e');
    } finally {
      await _cleanupAfterCall();
    }
  }

  Future<void> _cleanupAfterCall() async {
    try {
      if (liveKitService.isConnected) {
        await liveKitService.disconnect();
      }
    } catch (e) {
      logger.e('LiveKit cleanup error: $e');
    }

    _isLoading = false;
    _isInCall = false;
    _isMuted = false;
    _isVideoEnabled = true;
    _errorMessage = null;
    _currentConversationId = null;
    _currentRoomName = null;
    _currentCallKind = null;
    notifyListeners();
  }

  Future<void> _handleCallEnded(Map<String, dynamic> data) async {
    final conversationId = _pick(data, const [
      'conversationId',
      'conversation_id',
    ]);

    logger.i('call:ended => $conversationId');

    if (_currentConversationId != null &&
        _currentConversationId == conversationId) {
      await _cleanupAfterCall();
      final context = navigatorKey.currentContext;
      if (context != null) {
        Navigator.of(context, rootNavigator: true).maybePop();
      }
    }

    _incomingCallData = null;
    notifyListeners();
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
      logger.e('switchCamera error: $e');
      _errorMessage = 'Failed to switch camera';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _pick(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  @override
  void dispose() {
    _socketService.onIncomingCall = null;
    _socketService.onCallEnded = null;
    super.dispose();
  }
}
