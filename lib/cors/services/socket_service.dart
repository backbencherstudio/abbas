import 'dart:async';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;
  final Logger _logger = Logger();

  final StreamController<Map<String, dynamic>> _messageController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  final Set<String> _joinedConversations = {};
  Completer<void>? _connectionCompleter;

  bool _isConnecting = false;
  String? _lastToken;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect(String token) async {
    if (isConnected) {
      _logger.i('Socket already connected');
      return;
    }

    if (_isConnecting) {
      await _connectionCompleter?.future;
      return;
    }

    _isConnecting = true;
    _lastToken = token;
    _connectionCompleter = Completer<void>();

    _socket?.dispose();
    _socket = null;

    _socket = io.io(
      'http://192.168.7.14:4000/ws',
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1500)
          .setTimeout(15000)
          .setAuth({'token': token})
          .build(),
    );

    _setupListeners();
    _socket!.connect();

    try {
      await _connectionCompleter!.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Socket connection timeout'),
      );
    } finally {
      _isConnecting = false;
    }
  }

  void _setupListeners() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      _logger.i('Socket connected: ${_socket!.id}');
      if (!(_connectionCompleter?.isCompleted ?? true)) {
        _connectionCompleter?.complete();
      }

      final rooms = List<String>.from(_joinedConversations);
      _joinedConversations.clear();

      for (final room in rooms) {
        joinConversation(room);
      }
    });

    _socket!.onDisconnect((reason) {
      _logger.w('Socket disconnected: $reason');
    });

    _socket!.onConnectError((error) {
      _logger.e('Socket connect error: $error');
      if (!(_connectionCompleter?.isCompleted ?? true)) {
        _connectionCompleter?.completeError(error);
      }
    });

    _socket!.onError((error) {
      _logger.e('Socket error: $error');
    });

    _socket!.on('connection:ok', (data) {
      _logger.i('Socket auth ok: $data');
    });

    _socket!.on('message:new', _handleIncomingMessage);
    _socket!.on('newMessage', _handleIncomingMessage);
    _socket!.on('message', _handleIncomingMessage);
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      _logger.e('Incoming message parse error: $e');
    }
  }

  void joinConversation(String conversationId) {
    if (conversationId.trim().isEmpty) return;

    _joinedConversations.add(conversationId);

    if (!isConnected) return;

    _socket!.emit('conversation:join', {
      'conversationId': conversationId,
    });

    _logger.i('Joined conversation: $conversationId');
  }

  void leaveConversation(String conversationId) {
    if (conversationId.trim().isEmpty) return;

    _joinedConversations.remove(conversationId);

    if (!isConnected) return;

    _socket!.emit('conversation:leave', {
      'conversationId': conversationId,
    });

    _logger.i('Left conversation: $conversationId');
  }

  void sendMessage({
    required String conversationId,
    required String kind,
    required Map<String, dynamic> content,
  }) {
    if (!isConnected) return;

    _socket!.emit('message:send', {
      'conversationId': conversationId,
      'kind': kind,
      'content': content,
    });

    _logger.i('Sent realtime message to $conversationId');
  }

  void sendTyping(String conversationId, bool isTyping) {
    if (!isConnected) return;

    _socket!.emit('typing', {
      'conversationId': conversationId,
      'on': isTyping,
    });
  }

  void disconnect() {
    _joinedConversations.clear();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connectionCompleter = null;
    _isConnecting = false;
  }

  void dispose() {
    disconnect();
  }
}
