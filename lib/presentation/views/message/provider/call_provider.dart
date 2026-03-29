import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/api_client.dart';
import '../../../../cors/services/live_kit_service.dart';
import '../../../../cors/services/socket_call.dart';
import '../../../../cors/services/token_storage.dart';
import '../../../../main.dart';
import '../screens/video_call_screen.dart';

class CallProvider extends ChangeNotifier {
  CallProvider() {
    logger.i("🔥🔥🔥 CALLPROVIDER INITIALIZED! 🔥🔥🔥");

    _init();
  }

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));
  final LiveKitService liveKitService = LiveKitService();
  final SocketCall _socketService = SocketCall();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isInCall = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;

  String? _currentCallId;
  String? _currentRoomName;
  String? _currentCallKind;

  Map<String, dynamic>? _incomingCallData;
  OverlayEntry? _overlayEntry;

  bool get hasIncomingCall => _incomingCallData != null;
  Map<String, dynamic>? get incomingCallData => _incomingCallData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInCall => _isInCall;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  String? get currentCallKind => _currentCallKind;

  void _init() {
    if (liveKitService.isConnected) {
      liveKitService.disconnect();
    }
    _wireSocketCallbacks();
    _tryAutoConnect();
  }

  Future<void> _tryAutoConnect() async {
    try {
      final token = await TokenStorage().getToken();
      if (token != null && token.isNotEmpty) {
        if (!_socketService.isConnected) {
          logger.i("🔌 Auto-connecting socket on init...");
          _socketService.connect(token);
        }
      }
      _wireSocketCallbacks();
    } catch (e) {
      logger.e("Auto-connect failed: $e");
    }
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      String normalized = parts[1];
      while (normalized.length % 4 != 0) normalized += '=';
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = json['exp'] as int?;
      if (exp == null) return true;
      return DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(exp * 1000));
    } catch (e) {
      return true;
    }
  }

  void _wireSocketCallbacks() {
    logger.i("🔗 Wiring socket callbacks...");

    // ✅ Direct assignment with explicit function
    _socketService.onIncomingCall = (Map<String, dynamic> data) {
      logger.i("🔥🔥🔥 CALLBACK TRIGGERED! Data: $data");
      _handleIncomingCall(data);
    };

    _socketService.onCallEnded = (Map<String, dynamic> data) {
      logger.i("📵 Call ended callback triggered");
      _handleCallEnded(data);
    };

    logger.i("✅ Socket callbacks wired successfully");
  }

  void ensureSocketConnected(String token) {
    if (!_socketService.isConnected) {
      _socketService.connect(token);
    }
    _wireSocketCallbacks();
  }

  // ✅ Main incoming call handler
  void _handleIncomingCall(Map<String, dynamic> data) {
    logger.i("📲 Incoming call data received: $data");
    logger.i("🔥🔥🔥 _handleIncomingCall IS EXECUTING! 🔥🔥🔥");

    if (_isInCall) {
      logger.w("⚠️ Already in a call, ignoring incoming call.");
      return;
    }

    _incomingCallData = data;
    notifyListeners();

    // Vibrate phone
    HapticFeedback.heavyImpact();

    // Show dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCallDialog();
    });
  }
// ✅ Fallback notification
  void _showNotificationFallback() {
    logger.i("📱 Showing fallback notification");

    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      logger.e("❌ Cannot show notification - no context");
      return;
    }

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text("Incoming call from ${_incomingCallData!['fromUserId']}"),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: "Answer",
          onPressed: () => acceptIncomingCall(),
        ),
      ),
    );
  }
  // ✅ Direct dialog show method (simplest approach)
// ✅ Direct dialog show method (simplest approach)
  void _showCallDialog() {
    logger.i("🎯 _showCallDialog called");

    final ctx = navigatorKey.currentContext;
    logger.i("📱 Context: ${ctx != null ? 'available' : 'NULL'}");

    if (ctx == null) {
      logger.e("❌ Context is null");
      return;
    }

    final fromUserId = _incomingCallData!['fromUserId'] ?? 'Unknown';
    final kind = (_incomingCallData!['kind'] ?? 'VIDEO').toUpperCase();
    final conversationId = _incomingCallData!['conversationId'];

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text("Incoming ${kind} Call"),
        content: Text("From: $fromUserId"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              rejectIncomingCall();
            },
            child: Text("Decline", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await acceptIncomingCall();
              if (success) {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => VideoCallScreen(
                      conversationId: conversationId,
                      callKind: kind,
                    ),
                  ),
                );
              }
            },
            child: Text("Accept"),
          ),
        ],
      ),
    );
  }


  void _handleCallEnded(Map<String, dynamic> data) {
    logger.i("📵 Call ended");
    _overlayEntry?.remove();
    _overlayEntry = null;
    _incomingCallData = null;
    if (_isInCall) {
      leaveCall(data['conversationId'] ?? '');
    }
    notifyListeners();
  }

  void clearIncomingCall() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _incomingCallData = null;
    notifyListeners();
  }

  Future<bool> acceptIncomingCall() async {
    if (_incomingCallData == null) return false;
    final conversationId = _incomingCallData!['conversationId'];
    final kind = (_incomingCallData!['kind'] ?? 'VIDEO').toUpperCase();
    if (conversationId == null) return false;

    _currentCallKind = kind;
    clearIncomingCall();
    return await joinCall(conversationId, kind: kind);
  }

  void rejectIncomingCall() {
    clearIncomingCall();
    logger.i("❌ Call rejected");
  }

  // ── Call Methods ──────────────────────────────────────────────────────

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

      _currentCallId = startResponse.data?['callId'] ?? startResponse.data?['data']?['callId'];

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

  Future<bool> joinCall(String conversationId, {String kind = "VIDEO"}) async {
    _resetCallState();
    _isLoading = true;
    _currentCallKind = kind.toUpperCase();
    notifyListeners();

    try {
      if (liveKitService.isConnected) await liveKitService.disconnect();

      final response = await _apiClient.post(ApiEndpoints.joinCall(conversationId));

      if (!response.success) {
        _errorMessage = response.message ?? "Failed to join call";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final success = await _getLiveKitToken(conversationId, kind);
      if (success) {
        _isInCall = true;
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _getLiveKitToken(String conversationId, String kind) async {
    try {
      final tokenResponse = await _apiClient.post(ApiEndpoints.getToken(conversationId));

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
      return await _connectToLiveKit(token, url, roomName, kind);
    } catch (e) {
      _errorMessage = "Token request failed";
      logger.e("Token error: $e");
      return false;
    }
  }

  Future<bool> _connectToLiveKit(String token, String url, String roomName, String kind) async {
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
    _currentCallKind = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}