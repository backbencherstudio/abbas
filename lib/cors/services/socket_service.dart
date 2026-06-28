import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:flutter/foundation.dart';
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
  final List<SocketDataCallback> _callIncomingListeners = [];
  final List<SocketDataCallback> _callEndedListeners = [];
  final List<SocketDataCallback> _callParticipantJoinedListeners = [];
  final List<SocketDataCallback> _callParticipantLeftListeners = [];
  final List<SocketDataCallback> _callParticipantUpdatedListeners = [];
  final List<SocketDataCallback> _callDeclinedListeners = [];
  final List<SocketDataCallback> _callMessageUpdatedListeners = [];
  final List<VoidCallback> _connectionOkListeners = [];

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

  void addCallIncomingListener(SocketDataCallback listener) {
    if (!_callIncomingListeners.contains(listener)) {
      _callIncomingListeners.add(listener);
    }
  }

  void removeCallIncomingListener(SocketDataCallback listener) {
    _callIncomingListeners.remove(listener);
  }

  void addCallEndedListener(SocketDataCallback listener) {
    if (!_callEndedListeners.contains(listener)) {
      _callEndedListeners.add(listener);
    }
  }

  void removeCallEndedListener(SocketDataCallback listener) {
    _callEndedListeners.remove(listener);
  }

  void addCallParticipantJoinedListener(SocketDataCallback listener) {
    if (!_callParticipantJoinedListeners.contains(listener)) {
      _callParticipantJoinedListeners.add(listener);
    }
  }

  void removeCallParticipantJoinedListener(SocketDataCallback listener) {
    _callParticipantJoinedListeners.remove(listener);
  }

  void addCallParticipantLeftListener(SocketDataCallback listener) {
    if (!_callParticipantLeftListeners.contains(listener)) {
      _callParticipantLeftListeners.add(listener);
    }
  }

  void removeCallParticipantLeftListener(SocketDataCallback listener) {
    _callParticipantLeftListeners.remove(listener);
  }

  void addCallParticipantUpdatedListener(SocketDataCallback listener) {
    if (!_callParticipantUpdatedListeners.contains(listener)) {
      _callParticipantUpdatedListeners.add(listener);
    }
  }

  void removeCallParticipantUpdatedListener(SocketDataCallback listener) {
    _callParticipantUpdatedListeners.remove(listener);
  }

  void addCallDeclinedListener(SocketDataCallback listener) {
    if (!_callDeclinedListeners.contains(listener)) {
      _callDeclinedListeners.add(listener);
    }
  }

  void removeCallDeclinedListener(SocketDataCallback listener) {
    _callDeclinedListeners.remove(listener);
  }

  void addCallMessageUpdatedListener(SocketDataCallback listener) {
    if (!_callMessageUpdatedListeners.contains(listener)) {
      _callMessageUpdatedListeners.add(listener);
    }
  }

  void removeCallMessageUpdatedListener(SocketDataCallback listener) {
    _callMessageUpdatedListeners.remove(listener);
  }

  void addConnectionOkListener(VoidCallback listener) {
    if (!_connectionOkListeners.contains(listener)) {
      _connectionOkListeners.add(listener);
    }
  }

  void removeConnectionOkListener(VoidCallback listener) {
    _connectionOkListeners.remove(listener);
  }

  String? get userId => _userId;

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
      for (final listener in List<VoidCallback>.from(_connectionOkListeners)) {
        listener();
      }
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

    _socket!.on('call:incoming', (data) {
      _log('Event call:incoming — listeners: ${_callIncomingListeners.length}');
      for (final listener
          in List<SocketDataCallback>.from(_callIncomingListeners)) {
        listener(data);
      }
    });

    _socket!.on('call:ended', (data) {
      _log('Event call:ended — listeners: ${_callEndedListeners.length}');
      for (final listener
          in List<SocketDataCallback>.from(_callEndedListeners)) {
        listener(data);
      }
    });

    _socket!.on('call:participant_joined', (data) {
      for (final listener
          in List<SocketDataCallback>.from(_callParticipantJoinedListeners)) {
        listener(data);
      }
    });

    _socket!.on('call:participant_left', (data) {
      for (final listener
          in List<SocketDataCallback>.from(_callParticipantLeftListeners)) {
        listener(data);
      }
    });

    _socket!.on('call:participant_updated', (data) {
      for (final listener
          in List<SocketDataCallback>.from(_callParticipantUpdatedListeners)) {
        listener(data);
      }
    });

    _socket!.on('call:declined', (data) {
      for (final listener
          in List<SocketDataCallback>.from(_callDeclinedListeners)) {
        listener(data);
      }
    });

    _socket!.on('call:message_updated', (data) {
      for (final listener
          in List<SocketDataCallback>.from(_callMessageUpdatedListeners)) {
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
