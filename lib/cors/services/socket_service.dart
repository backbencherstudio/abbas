import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum SocketConnectionStatus {
  disconnected,
  connecting,
  connected,
  authenticated,
  error,
}

typedef SocketDataCallback = void Function(dynamic data);

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  io.Socket? _socket;
  SocketConnectionStatus status = SocketConnectionStatus.disconnected;
  bool _isConnecting = false;
  bool _coreHandlersAttached = false;
  String? _activeConversationId;
  String? _token;
  String? _userId;

  final List<SocketDataCallback> _newMessageListeners = [];
  final List<SocketDataCallback> _messageStatusListeners = [];
  final List<SocketDataCallback> _typingListeners = [];

  io.Socket? get socket => _socket;
  bool get isConnected => status == SocketConnectionStatus.connected ||
      status == SocketConnectionStatus.authenticated;

  void _log(String message) {
    logger.i('[ChatSocket] $message');
  }

  void addNewMessageListener(SocketDataCallback listener) {
    if (!_newMessageListeners.contains(listener)) {
      _newMessageListeners.add(listener);
    }
  }

  void removeNewMessageListener(SocketDataCallback listener) {
    _newMessageListeners.remove(listener);
  }

  void addMessageStatusListener(SocketDataCallback listener) {
    if (!_messageStatusListeners.contains(listener)) {
      _messageStatusListeners.add(listener);
    }
  }

  void removeMessageStatusListener(SocketDataCallback listener) {
    _messageStatusListeners.remove(listener);
  }

  void addTypingListener(SocketDataCallback listener) {
    if (!_typingListeners.contains(listener)) {
      _typingListeners.add(listener);
    }
  }

  void removeTypingListener(SocketDataCallback listener) {
    _typingListeners.remove(listener);
  }

  void connect(String token) {
    if (_token == token &&
        _socket != null &&
        (_socket!.connected || _isConnecting)) {
      _log('Already connected or connecting (status: ${status.name})');
      _joinActiveConversation();
      return;
    }

    _token = token;
    _isConnecting = true;
    status = SocketConnectionStatus.connecting;
    _log('Connecting to ${ApiEndpoints.socketNamespace} ...');

    _socket?.dispose();
    _coreHandlersAttached = false;
    _socket = io.io(
      ApiEndpoints.socketNamespace,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(20)
          .setReconnectionDelay(1000)
          .setTimeout(20000)
          .setAuth({'token': token})
          .build(),
    );

    _attachCoreHandlers();
    _socket!.connect();
  }

  void _attachCoreHandlers() {
    if (_socket == null || _coreHandlersAttached) return;
    _coreHandlersAttached = true;

    _socket!.onConnect((_) {
      _isConnecting = false;
      status = SocketConnectionStatus.connected;
      _log('Connected — socket id: ${_socket?.id}');
      _joinActiveConversation();
    });

    _socket!.onDisconnect((reason) {
      _isConnecting = false;
      status = SocketConnectionStatus.disconnected;
      _log('Disconnected — reason: $reason');
    });

    _socket!.onConnectError((error) {
      _isConnecting = false;
      status = SocketConnectionStatus.error;
      logger.e('[ChatSocket] Connect error: $error');
    });

    _socket!.on('connection:ok', (data) {
      status = SocketConnectionStatus.authenticated;
      if (data is Map) {
        _userId = data['user_id']?.toString() ?? data['userId']?.toString();
      }
      _log('Authenticated — user_id: $_userId | status: ${status.name}');
      _joinActiveConversation();
    });

    _socket!.on('connection:error', (data) {
      status = SocketConnectionStatus.error;
      logger.e('[ChatSocket] connection:error => $data');
    });

    _socket!.on('conversation:joined', (data) {
      _log('conversation:joined => $data');
    });

    _socket!.on('error:conversation', (data) {
      logger.e('[ChatSocket] error:conversation => $data');
    });

    _socket!.on('error:message', (data) {
      logger.e('[ChatSocket] error:message => $data');
    });

    _socket!.on('message:new', (data) {
      _log('Event message:new received — listeners: ${_newMessageListeners.length}');
      for (final listener in List<SocketDataCallback>.from(_newMessageListeners)) {
        listener(data);
      }
    });

    _socket!.on('message:status', (data) {
      for (final listener
          in List<SocketDataCallback>.from(_messageStatusListeners)) {
        listener(data);
      }
    });

    _socket!.on('typing', (data) {
      for (final listener in List<SocketDataCallback>.from(_typingListeners)) {
        listener(data);
      }
    });
  }

  void _joinActiveConversation() {
    final conversationId = _activeConversationId;
    if (conversationId != null && conversationId.trim().isNotEmpty) {
      joinConversation(conversationId);
    }
  }

  void joinConversation(String conversationId) {
    final trimmed = conversationId.trim();
    if (trimmed.isEmpty) return;

    _activeConversationId = trimmed;

    if (_socket != null && _socket!.connected) {
      _socket!.emit('conversation:join', {
        'conversation_id': trimmed,
      });
      _log('Emit conversation:join => $trimmed');
    } else {
      _log('Join queued — waiting for socket (status: ${status.name})');
    }
  }

  void leaveConversation() {
    _activeConversationId = null;
    _log('Left active conversation room');
  }

  void sendTyping({
    required String conversationId,
    required bool isTyping,
  }) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('typing', {
      'conversation_id': conversationId,
      'on': isTyping,
    });
  }

  void sendRead({
    required String conversationId,
    required String at,
  }) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('message:read', {
      'conversation_id': conversationId,
      'at': at,
    });
    _log('Emit message:read => conversation_id=$conversationId');
  }

  @Deprecated('Use addNewMessageListener instead')
  void onNewMessage(Function(dynamic data) callback) {
    addNewMessageListener(callback);
  }

  @Deprecated('Use removeNewMessageListener instead')
  void offNewMessage() {}

  @Deprecated('Use addMessageStatusListener instead')
  void onMessageStatus(Function(dynamic data) callback) {
    addMessageStatusListener(callback);
  }

  @Deprecated('Use removeMessageStatusListener instead')
  void offMessageStatus() {}

  @Deprecated('Use addTypingListener instead')
  void onTyping(Function(dynamic data) callback) {
    addTypingListener(callback);
  }

  @Deprecated('Use removeTypingListener instead')
  void offTyping() {}

  void onMessageRead(Function(dynamic data) callback) {
    _socket?.off('message:read');
    _socket?.on('message:read', callback);
  }

  void onConversationJoined(Function(dynamic data) callback) {
    _socket?.off('conversation:joined');
    _socket?.on('conversation:joined', callback);
  }

  void onPresenceUpdate(Function(dynamic data) callback) {
    _socket?.off('presence:update');
    _socket?.on('presence:update', callback);
  }

  void onCallIncoming(Function(dynamic data) callback) {
    _socket?.off('call:incoming');
    _socket?.on('call:incoming', callback);
  }

  void onCallEnded(Function(dynamic data) callback) {
    _socket?.off('call:ended');
    _socket?.on('call:ended', callback);
  }

  void offMessageRead() => _socket?.off('message:read');
  void offConversationJoined() => _socket?.off('conversation:joined');
  void offPresenceUpdate() => _socket?.off('presence:update');
  void offCallIncoming() => _socket?.off('call:incoming');
  void offCallEnded() => _socket?.off('call:ended');

  @Deprecated('Use REST POST for sending messages')
  void sendTextMessage({
    required String conversationId,
    required String text,
  }) {}

  @Deprecated('Legacy ack listener')
  void onMessageAck(Function(dynamic data) callback) {}

  @Deprecated('Legacy ack listener')
  void offMessageAck() {}

  void clearChatListeners() {}

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _coreHandlersAttached = false;
    status = SocketConnectionStatus.disconnected;
    _isConnecting = false;
    _activeConversationId = null;
    _token = null;
    _userId = null;
    _log('Disconnected manually');
  }
}
