import 'dart:async';
import 'dart:io';

import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:flutter/foundation.dart';
import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/services/socket_service.dart';
import 'package:abbas/cors/services/token_storage.dart';
import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:abbas/main.dart';
import 'package:abbas/presentation/views/message/model/call_model.dart';
import 'package:abbas/presentation/views/message/services/call_manager.dart';
import 'package:abbas/presentation/views/message/services/call_ringtone_service.dart';
import 'package:abbas/presentation/views/message/services/rtc_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';

class CallState {
  final CallSession? activeSession;
  final IncomingCallData? incomingCall;
  final bool isConnecting;
  final bool isLiveKitConnected;
  final String? error;
  final String? currentUserId;
  final String? displayTitle;

  const CallState({
    this.activeSession,
    this.incomingCall,
    this.isConnecting = false,
    this.isLiveKitConnected = false,
    this.error,
    this.currentUserId,
    this.displayTitle,
  });

  bool get hasIncoming => incomingCall != null;
  bool get isInCall => activeSession != null && isLiveKitConnected;

  CallState copyWith({
    CallSession? activeSession,
    IncomingCallData? incomingCall,
    bool clearIncoming = false,
    bool clearActive = false,
    bool? isConnecting,
    bool? isLiveKitConnected,
    String? error,
    bool clearError = false,
    String? currentUserId,
    String? displayTitle,
    bool clearDisplayTitle = false,
  }) {
    return CallState(
      activeSession: clearActive ? null : (activeSession ?? this.activeSession),
      incomingCall:
          clearIncoming ? null : (incomingCall ?? this.incomingCall),
      isConnecting: isConnecting ?? this.isConnecting,
      isLiveKitConnected: isLiveKitConnected ?? this.isLiveKitConnected,
      error: clearError ? null : (error ?? this.error),
      currentUserId: currentUserId ?? this.currentUserId,
      displayTitle:
          clearDisplayTitle ? null : (displayTitle ?? this.displayTitle),
    );
  }
}

final callProvider = StateNotifierProvider<CallNotifier, CallState>(
  (ref) => CallNotifier(
    rtcService: RtcService(),
    callManager: CallManager(),
    socketService: SocketService(),
  ),
);

class CallNotifier extends StateNotifier<CallState> {
  CallNotifier({
    required this.rtcService,
    required this.callManager,
    required this.socketService,
  }) : super(const CallState()) {
    _ensureInitialized();
  }

  final RtcService rtcService;
  final CallManager callManager;
  final SocketService socketService;

  bool _initialized = false;
  String? _trackedConversationId;

  void Function(dynamic)? _onIncoming;
  void Function(dynamic)? _onEnded;
  void Function(dynamic)? _onParticipantJoined;
  void Function(dynamic)? _onParticipantLeft;
  void Function(dynamic)? _onParticipantUpdated;
  void Function(dynamic)? _onDeclined;
  VoidCallback? _onConnectionOk;

  Future<void> ensureInitialized() => _ensureInitialized();

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;

    final userId = await UserIdStorage().getUserId();
    state = state.copyWith(currentUserId: userId);

    _registerSocketListeners();
    unawaited(_requestCallPermissions());

    final token = await TokenStorage().getToken();
    if (token != null && token.isNotEmpty) {
      socketService.connect(token);
    }
  }

  void _registerSocketListeners() {
    _onIncoming = (data) {
      if (data is! Map) return;
      final incoming = IncomingCallData.fromSocket(
        Map<String, dynamic>.from(data),
      );
      if (incoming.conversationId.isEmpty) return;
      if (state.isInCall || state.isConnecting) return;
      CallRingtoneService.instance.start();
      state = state.copyWith(incomingCall: incoming, clearError: true);
    };

    _onEnded = (data) async {
      if (data is! Map) return;
      final conversationId = data['conversation_id']?.toString();
      if (conversationId != null &&
          state.activeSession?.conversationId != conversationId &&
          state.incomingCall?.conversationId != conversationId) {
        return;
      }
      logger.i('[Call] call:ended received for $conversationId');
      await _cleanupCall(popRoute: true);
    };

    _onParticipantJoined = (data) {
      if (data is! Map) return;
      final conversationId = data['conversation_id']?.toString();
      if (conversationId != state.activeSession?.conversationId) return;
      final count = data['participant_count'];
      if (count is num) {
        state = state.copyWith(
          activeSession: state.activeSession?.copyWith(
            participantCount: count.toInt(),
          ),
        );
      }
    };

    _onParticipantLeft = (data) async {
      if (data is! Map) return;
      final conversationId = data['conversation_id']?.toString();
      if (conversationId != state.activeSession?.conversationId) return;
      final count = data['participant_count'];
      if (count is num) {
        final session = state.activeSession!.copyWith(
          participantCount: count.toInt(),
        );
        state = state.copyWith(activeSession: session);

        // DM: when the other person leaves, close our call UI too.
        if (session.isDmCall && count.toInt() <= 1 && state.isLiveKitConnected) {
          await _cleanupCall(popRoute: true);
        }
      }
    };

    _onParticipantUpdated = (data) {
      if (data is! Map) return;
      final conversationId = data['conversation_id']?.toString();
      if (conversationId != state.activeSession?.conversationId) return;
      final participant = data['participant'];
      if (participant is Map && state.activeSession != null) {
        state = state.copyWith(
          activeSession: state.activeSession!.copyWith(
            selfParticipant: CallParticipant.fromJson(
              Map<String, dynamic>.from(participant),
            ),
          ),
        );
      }
    };

    _onDeclined = (data) {
      if (data is! Map) return;
      final conversationId = data['conversation_id']?.toString();
      if (conversationId == state.activeSession?.conversationId) {
        // Group call — someone declined; keep call alive.
      }
    };

    _onConnectionOk = () {
      if (_trackedConversationId != null) {
        syncConversationState(
          _trackedConversationId!,
          showIncomingIfNeeded: true,
        );
      }
    };

    socketService.addCallIncomingListener(_onIncoming!);
    socketService.addCallEndedListener(_onEnded!);
    socketService.addCallParticipantJoinedListener(_onParticipantJoined!);
    socketService.addCallParticipantLeftListener(_onParticipantLeft!);
    socketService.addCallParticipantUpdatedListener(_onParticipantUpdated!);
    socketService.addCallDeclinedListener(_onDeclined!);
    socketService.addConnectionOkListener(_onConnectionOk!);
  }

  Future<void> trackConversation(
    String conversationId, {
    String? title,
    bool showIncomingIfNeeded = true,
  }) async {
    await _ensureInitialized();
    _trackedConversationId = conversationId;
    if (title != null && title.isNotEmpty) {
      state = state.copyWith(displayTitle: title);
    }
    await syncConversationState(
      conversationId,
      showIncomingIfNeeded: showIncomingIfNeeded,
    );
  }

  void untrackConversation(String conversationId) {
    if (_trackedConversationId == conversationId) {
      _trackedConversationId = null;
    }
  }

  Future<void> syncConversationState(
    String conversationId, {
    bool showIncomingIfNeeded = false,
  }) async {
    await _ensureInitialized();
    try {
      final session = await rtcService.getState(conversationId);
      if (session == null || !session.isOngoing) {
        if (state.incomingCall?.conversationId == conversationId) {
          await CallRingtoneService.instance.stop();
          state = state.copyWith(clearIncoming: true);
        }
        if (state.activeSession?.conversationId == conversationId &&
            !callManager.isConnected) {
          state = state.copyWith(clearActive: true);
        }
        return;
      }

      if (callManager.isConnected &&
          state.activeSession?.conversationId == conversationId) {
        state = state.copyWith(activeSession: session);
        return;
      }

      final userId = state.currentUserId;
      final isCaller = userId != null && session.startedBy == userId;

      state = state.copyWith(
        activeSession: session,
        displayTitle: state.displayTitle ?? session.conversationTitle,
      );

      if (showIncomingIfNeeded && !isCaller && !callManager.isConnected) {
        CallRingtoneService.instance.start();
        state = state.copyWith(
          incomingCall: IncomingCallData.fromSession(session),
        );
      }
    } catch (e) {
      logger.e('[Call] sync state error: $e');
    }
  }

  Future<void> _requestCallPermissions() async {
    await Permission.microphone.request();
    await Permission.camera.request();
    if (Platform.isAndroid) {
      await Permission.notification.request();
      await Permission.bluetoothConnect.request();
    }
  }

  Future<bool> _ensurePermissions(CallKind kind) async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return false;

    if (kind.isVideo) {
      final cam = await Permission.camera.request();
      if (!cam.isGranted) return false;
    }

    // Bluetooth for headset routing during calls (Android 12+).
    await Permission.bluetoothConnect.request();

    return true;
  }

  Future<void> startCall({
    required String conversationId,
    required CallKind kind,
    String? title,
  }) async {
    await _ensureInitialized();
    if (!await _ensurePermissions(kind)) {
      state = state.copyWith(error: 'Microphone permission is required');
      return;
    }

    state = state.copyWith(
      isConnecting: true,
      clearError: true,
      clearIncoming: true,
      displayTitle: title ?? state.displayTitle,
    );

    try {
      final session = await rtcService.startCall(conversationId, kind);
      await callManager.connect(session);
      state = state.copyWith(
        activeSession: session,
        isConnecting: false,
        isLiveKitConnected: true,
        clearIncoming: true,
      );
      _openCallScreen();
    } catch (e) {
      logger.e('[Call] start error: $e');
      state = state.copyWith(
        isConnecting: false,
        isLiveKitConnected: false,
        clearActive: true,
        error: e.toString(),
      );
    }
  }

  Future<void> acceptIncoming({String? title}) async {
    final incoming = state.incomingCall;
    if (incoming == null) return;

    await CallRingtoneService.instance.stop();

    if (!await _ensurePermissions(incoming.kind)) {
      state = state.copyWith(error: 'Permission denied');
      return;
    }

    state = state.copyWith(
      isConnecting: true,
      clearError: true,
      displayTitle: title ?? incoming.callerName ?? incoming.conversationTitle,
    );

    try {
      final session = await rtcService.joinCall(incoming.conversationId);
      await callManager.connect(session);
      state = state.copyWith(
        activeSession: session,
        isConnecting: false,
        isLiveKitConnected: true,
        clearIncoming: true,
      );
      _openCallScreen();
    } catch (e) {
      logger.e('[Call] accept error: $e');
      state = state.copyWith(
        isConnecting: false,
        clearIncoming: true,
        error: e.toString(),
      );
    }
  }

  Future<void> joinOngoingCall({
    required String conversationId,
    String? title,
  }) async {
    await _ensureInitialized();
    final session = state.activeSession;
    final kind = session?.kind ?? CallKind.audio;

    if (!await _ensurePermissions(kind)) {
      state = state.copyWith(error: 'Permission denied');
      return;
    }

    state = state.copyWith(
      isConnecting: true,
      clearError: true,
      displayTitle: title ?? state.displayTitle,
    );

    try {
      final joined = await rtcService.joinCall(conversationId);
      await callManager.connect(joined);
      state = state.copyWith(
        activeSession: joined,
        isConnecting: false,
        isLiveKitConnected: true,
        clearIncoming: true,
      );
      _openCallScreen();
    } catch (e) {
      logger.e('[Call] rejoin error: $e');
      state = state.copyWith(
        isConnecting: false,
        error: e.toString(),
      );
    }
  }

  Future<void> declineIncoming() async {
    final incoming = state.incomingCall;
    if (incoming == null) return;
    await CallRingtoneService.instance.stop();
    try {
      await rtcService.declineCall(incoming.conversationId);
    } catch (e) {
      logger.e('[Call] decline error: $e');
    } finally {
      state = state.copyWith(clearIncoming: true);
    }
  }

  /// Hang up: DM ends call for both; group only leaves this user.
  Future<void> hangUp() async {
    final session = state.activeSession;
    if (session == null) return;
    try {
      if (session.isDmCall) {
        await rtcService.endCall(session.conversationId);
      } else {
        await rtcService.leaveCall(session.conversationId);
      }
    } catch (e) {
      logger.e('[Call] hang up error: $e');
    } finally {
      await _cleanupCall(popRoute: true);
    }
  }

  Future<void> leaveCall() async => hangUp();

  Future<void> endCallForEveryone() async {
    final session = state.activeSession;
    if (session == null) return;
    try {
      await rtcService.endCall(session.conversationId);
    } catch (e) {
      logger.e('[Call] end error: $e');
    } finally {
      await _cleanupCall(popRoute: true);
    }
  }

  Future<void> toggleMic() async {
    final session = state.activeSession;
    if (session == null) return;
    final current = session.selfParticipant?.microphone ?? true;
    final next = !current;
    await callManager.toggleMic(next);
    try {
      final participant = await rtcService.updateMedia(
        session.conversationId,
        microphone: next,
      );
      state = state.copyWith(
        activeSession: session.copyWith(selfParticipant: participant),
      );
    } catch (e) {
      logger.e('[Call] mic sync error: $e');
    }
  }

  Future<void> toggleCamera() async {
    final session = state.activeSession;
    if (session == null || !session.kind.isVideo) return;
    final current = session.selfParticipant?.camera ?? true;
    final next = !current;
    await callManager.toggleCamera(next);
    try {
      final participant = await rtcService.updateMedia(
        session.conversationId,
        camera: next,
      );
      state = state.copyWith(
        activeSession: session.copyWith(selfParticipant: participant),
      );
    } catch (e) {
      logger.e('[Call] camera sync error: $e');
    }
  }

  Future<void> toggleSpeaker() async {
    await callManager.toggleSpeaker();
    state = state.copyWith();
  }

  Future<void> switchCamera() async {
    await callManager.switchCamera();
    state = state.copyWith();
  }

  /// LiveKit room closed (remote hang-up or network). Clears UI without REST call.
  Future<void> handleRemoteDisconnect() async {
    if (!state.isLiveKitConnected && !state.isConnecting) return;
    await _cleanupCall(popRoute: true);
  }

  Future<void> _cleanupCall({bool popRoute = false}) async {
    await CallRingtoneService.instance.stop();
    await callManager.disconnect();
    state = state.copyWith(
      clearActive: true,
      clearIncoming: true,
      isConnecting: false,
      isLiveKitConnected: false,
    );
    if (popRoute) {
      navigatorKey.currentState?.maybePop();
    }
  }

  void _openCallScreen() {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    final route = state.activeSession?.kind.isVideo == true
        ? RouteNames.videoCallScreen
        : RouteNames.audioCallScreen;
    navigatorKey.currentState?.pushNamed(route);
  }

  @override
  void dispose() {
    if (_onIncoming != null) {
      socketService.removeCallIncomingListener(_onIncoming!);
    }
    if (_onEnded != null) {
      socketService.removeCallEndedListener(_onEnded!);
    }
    if (_onParticipantJoined != null) {
      socketService.removeCallParticipantJoinedListener(_onParticipantJoined!);
    }
    if (_onParticipantLeft != null) {
      socketService.removeCallParticipantLeftListener(_onParticipantLeft!);
    }
    if (_onParticipantUpdated != null) {
      socketService.removeCallParticipantUpdatedListener(_onParticipantUpdated!);
    }
    if (_onDeclined != null) {
      socketService.removeCallDeclinedListener(_onDeclined!);
    }
    if (_onConnectionOk != null) {
      socketService.removeConnectionOkListener(_onConnectionOk!);
    }
    callManager.disconnect();
    super.dispose();
  }
}
