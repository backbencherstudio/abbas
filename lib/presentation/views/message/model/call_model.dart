enum CallKind { audio, video }

extension CallKindApi on CallKind {
  String get apiValue => this == CallKind.audio ? 'AUDIO' : 'VIDEO';

  static CallKind fromApi(String? value) {
    if (value?.toUpperCase() == 'AUDIO') return CallKind.audio;
    return CallKind.video;
  }

  bool get isVideo => this == CallKind.video;
}

class LiveKitCredentials {
  final String token;
  final String url;
  final String roomName;
  final bool audioOnlySuggested;

  const LiveKitCredentials({
    required this.token,
    required this.url,
    required this.roomName,
    this.audioOnlySuggested = false,
  });

  factory LiveKitCredentials.fromJson(Map<String, dynamic> json) {
    return LiveKitCredentials(
      token: json['token']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      roomName: json['room_name']?.toString() ?? '',
      audioOnlySuggested: json['audio_only_suggested'] == true,
    );
  }
}

class CallParticipant {
  final String id;
  final String userId;
  final bool camera;
  final bool microphone;
  final bool isScreenSharing;
  final String? name;
  final String? avatar;

  const CallParticipant({
    required this.id,
    required this.userId,
    this.camera = true,
    this.microphone = true,
    this.isScreenSharing = false,
    this.name,
    this.avatar,
  });

  factory CallParticipant.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : null;
    return CallParticipant(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? user?['id']?.toString() ?? '',
      camera: json['camera'] != false,
      microphone: json['microphone'] != false,
      isScreenSharing: json['is_screen_sharing'] == true,
      name: user?['name']?.toString(),
      avatar: user?['avatar']?.toString(),
    );
  }
}

class CallSession {
  final String id;
  final String conversationId;
  final CallKind kind;
  final String status;
  final String startedBy;
  final String? startedAt;
  final String? endedAt;
  final String? roomName;
  final int participantCount;
  final CallParticipant? selfParticipant;
  final List<CallParticipant> participants;
  final LiveKitCredentials? livekit;
  final bool alreadyActive;
  final String? conversationTitle;

  const CallSession({
    required this.id,
    required this.conversationId,
    required this.kind,
    this.status = 'ONGOING',
    this.startedBy = '',
    this.startedAt,
    this.endedAt,
    this.roomName,
    this.participantCount = 0,
    this.selfParticipant,
    this.participants = const [],
    this.livekit,
    this.alreadyActive = false,
    this.conversationTitle,
  });

  factory CallSession.fromJson(
    Map<String, dynamic> json, {
    String? conversationTitle,
  }) {
    final rawParticipants = json['participants'];
    return CallSession(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      kind: CallKindApi.fromApi(json['kind']?.toString()),
      status: json['status']?.toString() ?? 'ONGOING',
      startedBy: json['started_by']?.toString() ?? '',
      startedAt: json['started_at']?.toString(),
      endedAt: json['ended_at']?.toString(),
      roomName: json['room_name']?.toString(),
      participantCount: _asInt(json['participant_count']),
      selfParticipant: json['self_participant'] is Map
          ? CallParticipant.fromJson(
              Map<String, dynamic>.from(json['self_participant'] as Map),
            )
          : null,
      participants: rawParticipants is List
          ? rawParticipants
              .whereType<Map>()
              .map((e) => CallParticipant.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
      livekit: json['livekit'] is Map
          ? LiveKitCredentials.fromJson(
              Map<String, dynamic>.from(json['livekit'] as Map),
            )
          : null,
      alreadyActive: json['already_active'] == true,
      conversationTitle: conversationTitle ??
          (json['conversation'] is Map
              ? Map<String, dynamic>.from(json['conversation'] as Map)['title']
                  ?.toString()
              : null),
    );
  }

  bool get isOngoing => status.toUpperCase() == 'ONGOING';

  CallSession copyWith({
    CallParticipant? selfParticipant,
    int? participantCount,
    List<CallParticipant>? participants,
    LiveKitCredentials? livekit,
  }) {
    return CallSession(
      id: id,
      conversationId: conversationId,
      kind: kind,
      status: status,
      startedBy: startedBy,
      startedAt: startedAt,
      endedAt: endedAt,
      roomName: roomName,
      participantCount: participantCount ?? this.participantCount,
      selfParticipant: selfParticipant ?? this.selfParticipant,
      participants: participants ?? this.participants,
      livekit: livekit ?? this.livekit,
      alreadyActive: alreadyActive,
      conversationTitle: conversationTitle,
    );
  }
}

class IncomingCallData {
  final String conversationId;
  final String callSessionId;
  final CallKind kind;
  final String startedBy;
  final String? startedAt;
  final String? conversationTitle;
  final String? callerName;
  final String? callerAvatar;

  const IncomingCallData({
    required this.conversationId,
    required this.callSessionId,
    required this.kind,
    required this.startedBy,
    this.startedAt,
    this.conversationTitle,
    this.callerName,
    this.callerAvatar,
  });

  factory IncomingCallData.fromSocket(Map<String, dynamic> json) {
    final caller = json['caller'] is Map
        ? Map<String, dynamic>.from(json['caller'] as Map)
        : null;
    return IncomingCallData(
      conversationId: json['conversation_id']?.toString() ?? '',
      callSessionId: json['call_session_id']?.toString() ?? '',
      kind: CallKindApi.fromApi(json['kind']?.toString()),
      startedBy: json['started_by']?.toString() ?? '',
      startedAt: json['started_at']?.toString(),
      conversationTitle: json['conversation_title']?.toString(),
      callerName: caller?['name']?.toString(),
      callerAvatar: caller?['avatar']?.toString(),
    );
  }

  factory IncomingCallData.fromSession(CallSession session) {
    return IncomingCallData(
      conversationId: session.conversationId,
      callSessionId: session.id,
      kind: session.kind,
      startedBy: session.startedBy,
      startedAt: session.startedAt,
      conversationTitle: session.conversationTitle,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
