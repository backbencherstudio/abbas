import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  io.Socket? _socket;
  bool isConnected = false;
  bool _isConnecting = false;
  String? _activeConversationId;

  io.Socket? get socket => _socket;

  void connect(String token) {
    if (_socket != null && (_socket!.connected || _isConnecting)) {
      debugPrint('✅ Socket already connected/connecting');
      return;
    }

    _isConnecting = true;

    _socket = io.io(
      ApiEndpoints.socketNamespace,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(20)
          .setReconnectionDelay(1000)
          .setTimeout(20000)
          .setAuth({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.onConnect((_) {
      isConnected = true;
      _isConnecting = false;
      debugPrint('✅ Socket connected: ${_socket?.id}');

      final conversationId = _activeConversationId;
      if (conversationId != null && conversationId.trim().isNotEmpty) {
        joinConversation(conversationId);
      }
    });

    _socket!.onDisconnect((reason) {
      isConnected = false;
      _isConnecting = false;
      debugPrint('❌ Socket disconnected: $reason');
    });

    _socket!.onConnectError((error) {
      isConnected = false;
      _isConnecting = false;
      debugPrint('❌ Socket connect error: $error');
    });

    _socket!.onError((error) {
      debugPrint('❌ Socket error: $error');
    });

    _socket!.on('connection:ok', (data) {
      debugPrint('✅ connection:ok => $data');
    });

    _socket!.on('connection:error', (data) {
      debugPrint('❌ connection:error => $data');
    });

    _socket!.connect();
  }

  void joinConversation(String conversationId) {
    final trimmed = conversationId.trim();
    if (trimmed.isEmpty) return;

    _activeConversationId = trimmed;

    if (_socket != null && _socket!.connected) {
      _socket!.emit('conversation:join', {
        'conversationId': trimmed,
      });
      debugPrint('✅ conversation:join => $trimmed');
    } else {
      debugPrint('⚠️ join pending until socket connected');
    }
  }

  void sendTextMessage({
    required String conversationId,
    required String text,
  }) {
    if (_socket == null || !_socket!.connected) {
      debugPrint('⚠️ Socket not connected, cannot send');
      return;
    }

    _socket!.emit('message:send', {
      'conversationId': conversationId,
      'kind': 'TEXT',
      'content': {
        'text': text.trim(),
      },
    });
  }

  void sendTyping({
    required String conversationId,
    required bool isTyping,
  }) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('typing', {
      'conversationId': conversationId,
      'on': isTyping,
    });
  }

  void sendRead({
    required String conversationId,
    String? at,
  }) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('message:read', {
      'conversationId': conversationId,
      if (at != null) 'at': at,
    });
  }

  void onNewMessage(Function(dynamic data) callback) {
    _socket?.off('message:new');
    _socket?.on('message:new', callback);
  }

  void onMessageAck(Function(dynamic data) callback) {
    _socket?.off('message:ack');
    _socket?.on('message:ack', callback);
  }

  void onTyping(Function(dynamic data) callback) {
    _socket?.off('typing');
    _socket?.on('typing', callback);
  }

  void onMessageRead(Function(dynamic data) callback) {
    _socket?.off('message:read');
    _socket?.on('message:read', callback);
  }

  void onConversationJoined(Function(dynamic data) callback) {
    _socket?.off('conversation:joined');
    _socket?.on('conversation:joined', callback);
  }

  void onCallIncoming(Function(dynamic data) callback) {
    _socket?.off('call:incoming');
    _socket?.on('call:incoming', callback);
  }

  void onCallEnded(Function(dynamic data) callback) {
    _socket?.off('call:ended');
    _socket?.on('call:ended', callback);
  }

  void offNewMessage() => _socket?.off('message:new');
  void offMessageAck() => _socket?.off('message:ack');
  void offTyping() => _socket?.off('typing');
  void offMessageRead() => _socket?.off('message:read');
  void offConversationJoined() => _socket?.off('conversation:joined');
  void offCallIncoming() => _socket?.off('call:incoming');
  void offCallEnded() => _socket?.off('call:ended');

  void clearListeners() {
    _socket?.clearListeners();
  }

  void disconnect() {
    _socket?.disconnect();
    isConnected = false;
    _isConnecting = false;
    debugPrint('Socket disconnected manually');
  }
}
