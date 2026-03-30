import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketCall with ChangeNotifier {
  SocketCall._internal();
  static final SocketCall instance = SocketCall._internal();
  factory SocketCall() => instance;
  static const String _baseUrl =
      'https://occupations-love-routers-discovery.trycloudflare.com';
  static const String _namespace = '/ws';

  IO.Socket? _socket;
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  IO.Socket? get socket => _socket;

  Function(Map<String, dynamic>)? onIncomingCall;
  Function(Map<String, dynamic>)? onCallEnded;
  Function(Map<String, dynamic>)? onNewMessage;
  Function(Map<String, dynamic>)? onTyping;
  Function(Map<String, dynamic>)? onPresenceUpdate;
  Function(String conversationId)? onConversationJoined;

  void connect(String token) {
    if (_socket != null && _isConnected) {
      logger.i(" Socket already connected");
      return;
    }

    if (_socket != null) {
      try {
        _socket!.dispose();
      } catch (_) {}
      _socket = null;
    }

    logger.i(" Connecting socket to $_baseUrl$_namespace ...");

    _socket = IO.io(
      '$_baseUrl$_namespace',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionAttempts(8)
          .setReconnectionDelay(1000)
          .setTimeout(10000)
          .enableAutoConnect()
          .build(),
    );

    _attachListeners();
    _socket!.connect();
  }

  void _attachListeners() {
    _socket?.onConnect((_) {
      _isConnected = true;
      logger.i(" Socket connected — id: ${_socket?.id}");
      notifyListeners();
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      logger.w(" Socket disconnected");
      notifyListeners();
    });

    _socket?.onConnectError((err) {
      _isConnected = false;
      logger.e(" Socket connect error: $err");
      notifyListeners();
    });

    _socket?.onError((err) {
      logger.e("Socket error: $err");
    });

    _socket?.on('connection:ok', (data) {
      logger.i(" Server confirmed connection: $data");
    });

    _socket?.on('connection:error', (data) {
      logger.e(" Server rejected connection: $data");
      disconnect();
    });

    // ── Call events ──────────────────────────────────────────────────
    _socket?.on('call:incoming', (data) {
      logger.i(" call:incoming → $data");
      final map = _toMap(data);
      if (map != null) onIncomingCall?.call(map);
    });

    _socket?.on('call:ended', (data) {
      logger.i(" call:ended → $data");
      final map = _toMap(data);
      if (map != null) onCallEnded?.call(map);
    });

    // ── Chat events ──────────────────────────────────────────────────
    _socket?.on('message:new', (data) {
      final map = _toMap(data);
      if (map != null) onNewMessage?.call(map);
    });

    _socket?.on('typing', (data) {
      final map = _toMap(data);
      if (map != null) onTyping?.call(map);
    });

    _socket?.on('presence:update', (data) {
      final map = _toMap(data);
      if (map != null) onPresenceUpdate?.call(map);
    });

    _socket?.on('conversation:joined', (data) {
      logger.i(" conversation:joined → $data");
      final map = _toMap(data);
      if (map != null) {
        onConversationJoined?.call(map['conversationId'] ?? '');
      }
    });
  }

  void joinConversation(String conversationId) {
    _emit('conversation:join', {'conversationId': conversationId});
  }

  void sendTyping(String conversationId, {required bool isTyping}) {
    _emit('typing', {'conversationId': conversationId, 'on': isTyping});
  }

  void sendTextMessage(String conversationId, String text) {
    _emit('message:send', {
      'conversationId': conversationId,
      'kind': 'TEXT',
      'content': {'text': text},
    });
  }

  void _emit(String event, Map<String, dynamic> data) {
    if (!_isConnected || _socket == null) {
      logger.w(" Cannot emit '$event' — socket not connected");
      return;
    }
    logger.d(" emit '$event': $data");
    _socket!.emit(event, data);
  }

  void disconnect() {
    try {
      _socket?.disconnect();
      _socket?.dispose();
    } catch (e) {
      logger.e("Socket disconnect error: $e");
    } finally {
      _socket = null;
      _isConnected = false;
      // onIncomingCall = null;
      // onCallEnded = null;
      // onNewMessage = null;
      // onTyping = null;
      // onPresenceUpdate = null;
      // onConversationJoined = null;
      notifyListeners();
    }
  }

  Map<String, dynamic>? _toMap(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
