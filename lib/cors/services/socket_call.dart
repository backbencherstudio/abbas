import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketCall with ChangeNotifier {
  SocketCall._internal();
  static final SocketCall instance = SocketCall._internal();
  factory SocketCall() => instance;

  io.Socket? _socket;
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  io.Socket? get socket => _socket;

  Function(Map<String, dynamic>)? onIncomingCall;
  Function(Map<String, dynamic>)? onCallEnded;
  Function(Map<String, dynamic>)? onNewMessage;
  Function(Map<String, dynamic>)? onTyping;
  Function(Map<String, dynamic>)? onPresenceUpdate;
  Function(String conversationId)? onConversationJoined;

  void connect(String token) {
    if (_socket != null && (_socket!.connected || _isConnected)) {
      logger.i('Socket already connected');
      return;
    }

    disconnect();

    logger.i('Connecting socket to ${ApiEndpoints.socketNamespace}');
    _socket = io.io(
      ApiEndpoints.socketNamespace,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .setTimeout(10000)
          .setAuth({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _attachListeners();
    _socket!.connect();
  }

  void _attachListeners() {
    _socket?.onConnect((_) {
      _isConnected = true;
      logger.i('Socket connected: ${_socket?.id}');
      notifyListeners();
    });

    _socket?.onDisconnect((reason) {
      _isConnected = false;
      logger.w('Socket disconnected: $reason');
      notifyListeners();
    });

    _socket?.onConnectError((error) {
      _isConnected = false;
      logger.e('Socket connect error: $error');
      notifyListeners();
    });

    _socket?.onError((error) {
      logger.e('Socket error: $error');
    });

    _socket?.on('connection:ok', (data) {
      logger.i('connection:ok => $data');
    });

    _socket?.on('connection:error', (data) {
      logger.e('connection:error => $data');
    });

    _socket?.on('call:incoming', (data) {
      final map = _toMap(data);
      if (map != null) onIncomingCall?.call(map);
    });

    _socket?.on('call:ended', (data) {
      final map = _toMap(data);
      if (map != null) onCallEnded?.call(map);
    });

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
      final map = _toMap(data);
      if (map != null) {
        onConversationJoined?.call((map['conversationId'] ?? '').toString());
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
      'content': {'text': text.trim()},
    });
  }

  void sendRead(String conversationId, {String? at}) {
    _emit('message:read', {
      'conversationId': conversationId,
      if (at != null) 'at': at,
    });
  }

  void _emit(String event, Map<String, dynamic> data) {
    if (!_isConnected || _socket == null) {
      logger.w("Cannot emit '$event' - socket not connected");
      return;
    }
    logger.d("emit '$event' => $data");
    _socket!.emit(event, data);
  }

  void disconnect() {
    try {
      _socket?.clearListeners();
      _socket?.disconnect();
      _socket?.dispose();
    } catch (e) {
      logger.e('Socket disconnect error: $e');
    } finally {
      _socket = null;
      _isConnected = false;
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
