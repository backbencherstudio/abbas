// call_provider.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/network/api_response_model.dart';
import '../../../../cors/services/api_client.dart';
import '../../../../cors/services/live_kit_service.dart';

class CallProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();
  final LiveKitService liveKitService = LiveKitService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isInCall = false;
  bool _isMuted = false;
  String? _currentCallId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInCall => _isInCall;
  bool get isMuted => _isMuted;
  String? get currentCallId => _currentCallId;

  /// Start a new call
  Future<bool> startCall(String conversationId, {String kind = "AUDIO"}) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      // Call the start endpoint
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.startCall(conversationId),
        body: {"kind": kind},
      );

      logger.i("Start Call Response: ${response.data}");

      if (response.success && response.data != null) {
        // Store callId from response
        _currentCallId = response.data!['callId'];

        // After starting the call, you need to get a token
        // You might need to call a different endpoint to get the LiveKit token
        // For now, we'll assume the call is started
        _isInCall = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? "Failed to start call";
        logger.e("Start Call Error: ${_errorMessage}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Start Call Error: $error");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Join an existing call
  Future<bool> joinCall(String conversationId) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.joinCall(conversationId),
        body: {},
      );

      if (response.success) {
        _isInCall = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? "Failed to join call";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Join Call Error: $error");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Leave call
  Future<void> leaveCall(String conversationId) async {
    try {
      // Notify server
      await _apiClient.post(
        ApiEndpoints.endCall(conversationId),
        body: {},
      );
    } catch (e) {
      logger.e("Leave call API error: $e");
    } finally {
      // Disconnect from LiveKit
      liveKitService.leaveCall();
      _isInCall = false;
      _isMuted = false;
      _currentCallId = null;
      notifyListeners();
    }
  }

  /// End call (for host)
  Future<void> endCall(String conversationId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.endCall(conversationId),
        body: {},
      );
    } catch (e) {
      logger.e("End call error: $e");
    } finally {
      liveKitService.leaveCall();
      _isInCall = false;
      _currentCallId = null;
      notifyListeners();
    }
  }

  /// Toggle mute
  void toggleMute() {
    _isMuted = !_isMuted;
    // Here you would also call LiveKit service to mute/unmute
    // liveKitService.toggleAudio();
    notifyListeners();
  }

  /// Check RTC health
  Future<bool> checkHealth() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.rtcHealth);
      return response.success;
    } catch (e) {
      logger.e("Health check failed: $e");
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}