// call_provider.dart
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
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
    ),
  );
  final LiveKitService liveKitService = LiveKitService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isInCall = false;
  bool _isMuted = false;
  String? _currentCallId;
  String? _currentRoomName;
  String? _liveKitUrl;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInCall => _isInCall;
  bool get isMuted => _isMuted;
  String? get currentCallId => _currentCallId;
  String? get currentRoomName => _currentRoomName;

  /// Start a new call
  Future<bool> startCall(String conversationId, {String kind = "AUDIO"}) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    logger.i("📞 ===== STARTING CALL =====");
    logger.i("   Conversation ID: $conversationId");
    logger.i("   Call Kind: $kind");

    try {
      // First, ensure any previous connection is cleaned up
      if (liveKitService.isConnected) {
        logger.i("🔄 Previous LiveKit connection found, disconnecting...");
        liveKitService.leaveCall();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Step 1: Start the call
      logger.i("📡 Calling start endpoint: ${ApiEndpoints.startCall(conversationId)}");

      final ApiResponseModel startResponse = await _apiClient.post(
        ApiEndpoints.startCall(conversationId),
        body: {"kind": kind},
      );

      logger.i("📨 Start Call Response: ${startResponse.data}");

      if (startResponse.success && startResponse.data != null) {
        // Store callId from response
        _currentCallId = startResponse.data!['callId'] ?? startResponse.data!['data']?['callId'];

        logger.i("✅ Call started successfully!");
        logger.i("   Call ID: $_currentCallId");

        // Step 2: Get LiveKit token
        final tokenSuccess = await _getLiveKitToken(conversationId, kind);

        if (tokenSuccess) {
          _isInCall = true;
          _isLoading = false;
          notifyListeners();
          logger.i("🎉 Call setup complete!");
          return true;
        } else {
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = startResponse.message ?? "Failed to start call";
        logger.e("❌ Start Call Failed: ${_errorMessage}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("💥 Start Call Exception: $error");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get LiveKit token from backend
  Future<bool> _getLiveKitToken(String conversationId, String kind) async {
    try {
      logger.i("🔑 ===== GETTING LIVEKIT TOKEN =====");
      logger.i("   Conversation ID: $conversationId");

      final ApiResponseModel tokenResponse = await _apiClient.post(
        ApiEndpoints.getToken(conversationId),
        body: {}, // Empty body as per docs
      );

      logger.i("📨 Token Response: ${tokenResponse.data}");

      if (tokenResponse.success && tokenResponse.data != null) {
        final tokenData = tokenResponse.data!['data'] ?? tokenResponse.data;

        final token = tokenData['token'];
        final roomName = tokenData['roomName'];
        final url = tokenData['url'];
        final audioOnlySuggested = tokenData['audioOnlySuggested'] ?? (kind == "AUDIO");

        if (token != null && roomName != null && url != null) {
          _currentRoomName = roomName;
          _liveKitUrl = url;

          logger.i("✅ Token received successfully!");
          logger.i("   Room Name: $roomName");
          logger.i("   LiveKit URL: $url");
          logger.i("   Audio Only Suggested: $audioOnlySuggested");
          logger.i("   Token: ${token.substring(0, 20)}... (truncated)");

          // Connect to LiveKit
          return await _connectToLiveKit(token, url, roomName, kind);
        } else {
          _errorMessage = "Invalid token response from server";
          logger.e("❌ Invalid token data: $tokenData");
          return false;
        }
      } else {
        _errorMessage = tokenResponse.message ?? "Failed to get LiveKit token";
        logger.e("❌ Token Error: ${_errorMessage}");
        return false;
      }
    } catch (e) {
      logger.e("❌ Error getting token: $e");
      _errorMessage = e.toString();
      return false;
    }
  }

  /// Connect to LiveKit room
  Future<bool> _connectToLiveKit(String token, String url, String roomName, String kind) async {
    try {
      logger.i("🔌 ===== CONNECTING TO LIVEKIT =====");
      logger.i("   URL: $url");
      logger.i("   Room: $roomName");
      logger.i("   Audio Only: ${kind == "AUDIO"}");

      await liveKitService.connectToRoom(
        url: url,
        token: token,
        roomName: roomName,
        audioOnly: kind == "AUDIO",
      );

      logger.i("✅ Successfully connected to LiveKit room!");
      return true;
    } catch (e) {
      logger.e("❌ Failed to connect to LiveKit: $e");
      _errorMessage = "Media connection failed";
      return false;
    }
  }

  /// Join an existing active call
  Future<bool> joinCall(String conversationId) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    logger.i("🔌 ===== JOINING CALL =====");
    logger.i("   Conversation ID: $conversationId");

    try {
      // First, ensure any previous connection is cleaned up
      if (liveKitService.isConnected) {
        logger.i("🔄 Previous LiveKit connection found, disconnecting...");
        liveKitService.leaveCall();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Step 1: Join the call
      logger.i("📡 Calling join endpoint: ${ApiEndpoints.joinCall(conversationId)}");

      final ApiResponseModel joinResponse = await _apiClient.post(
        ApiEndpoints.joinCall(conversationId),
        body: {},
      );

      logger.i("📨 Join Response: ${joinResponse.data}");

      if (joinResponse.success) {
        logger.i("✅ Successfully joined call");

        // Step 2: Get LiveKit token
        final tokenSuccess = await _getLiveKitToken(conversationId, "AUDIO");

        if (tokenSuccess) {
          _isInCall = true;
          _isLoading = false;
          notifyListeners();
          logger.i("🎉 Successfully joined and connected to call!");
          return true;
        } else {
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = joinResponse.message ?? "Failed to join call";
        logger.e("❌ Join Failed: ${_errorMessage}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("💥 Join Call Exception: $error");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Leave call (participant leaves but call continues for others)
  Future<void> leaveCall(String conversationId) async {
    logger.i("👋 ===== LEAVING CALL =====");
    logger.i("   Conversation ID: $conversationId");
    logger.i("   Call ID: $_currentCallId");

    try {
      // Notify server that user is leaving
      logger.i("📡 Calling leave endpoint: ${ApiEndpoints.leaveCall(conversationId)}");

      final response = await _apiClient.post(
        ApiEndpoints.leaveCall(conversationId),
        body: {},
      );

      logger.i("📨 Leave Response: ${response.success}");
      if (response.data != null) {
        logger.i("   Response data: ${response.data}");
      }

    } catch (e) {
      logger.e("❌ Leave call API error: $e");
    } finally {
      // Disconnect from LiveKit
      logger.i("🔌 Disconnecting from LiveKit...");
      liveKitService.leaveCall();

      _resetCallState();

      logger.i("✅ Successfully left call");
    }
  }

  /// End call (host ends call for everyone)
  Future<void> endCall(String conversationId) async {
    logger.i("🛑 ===== ENDING CALL =====");
    logger.i("   Conversation ID: $conversationId");
    logger.i("   Call ID: $_currentCallId");

    try {
      logger.i("📡 Calling end endpoint: ${ApiEndpoints.endCall(conversationId)}");

      final response = await _apiClient.post(
        ApiEndpoints.endCall(conversationId),
        body: {},
      );

      logger.i("📨 End Response: ${response.success}");

      if (response.data != null) {
        logger.i("   Response data: ${response.data}");
      }

      logger.i("✅ End call API successful");
    } catch (e) {
      logger.e("❌ End call error: $e");
    } finally {
      liveKitService.leaveCall();
      _resetCallState();
    }
  }

  /// Reset call state
  void _resetCallState() {
    _isInCall = false;
    _isMuted = false;
    _currentCallId = null;
    _currentRoomName = null;
    _liveKitUrl = null;
    notifyListeners();
  }

  /// Toggle mute
  void toggleMute() {
    _isMuted = !_isMuted;
    logger.i("🔊 Toggle mute: ${_isMuted ? 'Muted' : 'Unmuted'}");

    if (_isMuted) {
      liveKitService.disableAudio();
    } else {
      liveKitService.enableAudio();
    }

    notifyListeners();
  }

  /// Check RTC health
  Future<bool> checkHealth() async {
    logger.i("🩺 ===== RTC HEALTH CHECK =====");

    try {
      final response = await _apiClient.get(ApiEndpoints.rtcHealth);

      logger.i("✅ Health check successful!");

      if (response.data != null) {
        logger.i("📦 Health Check Details:");
        response.data!.forEach((key, value) {
          if (key == 'url') {
            logger.i("   • $key: $value (LiveKit Server)");
          } else if (key == 'tokenTtlSeconds') {
            logger.i("   • $key: $value seconds (${value ~/ 60} minutes)");
          } else {
            logger.i("   • $key: $value");
          }
        });
      }

      return response.success;
    } catch (e) {
      logger.e("❌ Health check failed: $e");
      return false;
    }
  }

  /// Clear error
  void clearError() {
    if (_errorMessage != null) {
      logger.i("🧹 Clearing error: $_errorMessage");
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Print current state
  void printState() {
    logger.i("📱 ===== CALL PROVIDER STATE =====");
    logger.i("   Loading: $_isLoading");
    logger.i("   In Call: $_isInCall");
    logger.i("   Muted: $_isMuted");
    logger.i("   Call ID: $_currentCallId");
    logger.i("   Room Name: $_currentRoomName");
    logger.i("   LiveKit URL: $_liveKitUrl");
    logger.i("   Error: $_errorMessage");
    logger.i("   LiveKit Connected: ${liveKitService.isConnected}");
    logger.i("=================================");
  }
}