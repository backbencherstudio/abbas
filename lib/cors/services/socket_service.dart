import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';


class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  final Logger _logger = Logger();

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool get isConnected => _socket?.connected ?? false;
  String? currentUserId;

  Completer<void>? _connectionCompleter;
  final Set<String> _joinedConversations = {};

  // Keep track of active listeners to avoid duplicates
  StreamSubscription? _messageSubscription;

  Future<void> connect(String token) async {
    if (_socket != null && _socket!.connected) {
      _logger.i("Socket already connected");
      return;
    }

    _connectionCompleter = Completer<void>();

    final uri = 'http://192.168.7.14:4000/ws';

    _socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _setupListeners();
    _socket!.connect();

    await _connectionCompleter!.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception('Socket connection timeout'),
    );
  }

  void _setupListeners() {
    _socket!.onConnect((_) {
      _logger.i('✅ Socket Connected to /ws');
      _connectionCompleter?.complete();
      _joinedConversations.clear();
    });

    _socket!.onConnectError((err) {
      _logger.e('❌ Socket Connect Error: $err');
      if (_connectionCompleter?.isCompleted == false) {
        _connectionCompleter?.completeError(err);
      }
    });

    _socket!.on('connection:ok', (data) {
      currentUserId = data['userId'] as String?;
      _logger.i('Backend Auth Success - User: $currentUserId');
    });

    // Only one listener for messages
    _socket!.on('message:new', (data) {
      if (data is Map<String, dynamic>) {
        _messageController.add(data);
        _logger.i('New message received from: ${data['conversationId']}');
      }
    });

    _socket!.on('error:message', (data) {
      _logger.e('Message Error: ${data['message'] ?? data}');
    });
  }

  void joinConversation(String conversationId) {
    if (!isConnected || _joinedConversations.contains(conversationId)) return;

    _socket!.emit('conversation:join', {'conversationId': conversationId});
    _joinedConversations.add(conversationId);
    _logger.i('Joined conversation: $conversationId');
  }

  void leaveConversation(String conversationId) {
    if (!isConnected) return;
    if (_joinedConversations.contains(conversationId)) {
      _socket!.emit('conversation:leave', {'conversationId': conversationId});
      _joinedConversations.remove(conversationId);
      _logger.i('Left conversation: $conversationId');
    }
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
  }

  void sendTyping(String conversationId, bool isTyping) {
    if (isConnected) {
      _socket!.emit('typing', {
        'conversationId': conversationId,
        'on': isTyping,
      });
    }
  }

  void disconnect() {
    _joinedConversations.clear();
    _messageSubscription?.cancel();
    _socket?.disconnect();
    _socket = null;
    _connectionCompleter = null;
  }

  void dispose() {
    _messageController.close();
    disconnect();
  }
}
