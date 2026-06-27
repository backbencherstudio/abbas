import 'package:abbas/presentation/views/message/model/conversation_model.dart';

class ConversationDetail {
  final String id;
  final String? title;
  final String? avatar;
  final ConversationType type;
  final int totalMembers;
  final bool isSilenced;
  final String? mutedUntil;
  final ConversationParticipant? participant;

  const ConversationDetail({
    required this.id,
    this.title,
    this.avatar,
    this.type = ConversationType.unknown,
    this.totalMembers = 0,
    this.isSilenced = false,
    this.mutedUntil,
    this.participant,
  });

  factory ConversationDetail.fromJson(Map<String, dynamic> json) {
    return ConversationDetail(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString(),
      avatar: json['avatar']?.toString(),
      type: ConversationType.fromApi(json['type']?.toString()),
      totalMembers: _asInt(json['total_members']),
      isSilenced: json['is_silenced'] == true,
      mutedUntil: json['muted_until']?.toString(),
      participant: json['participant'] is Map
          ? ConversationParticipant.fromJson(
              Map<String, dynamic>.from(json['participant'] as Map),
            )
          : null,
    );
  }

  String displayTitle(String? currentUserId) {
    if (type.isGroup) {
      final t = title?.trim();
      return (t != null && t.isNotEmpty) ? t : 'Group';
    }
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    return participant?.name ?? 'Direct Message';
  }

  String? displayAvatar() {
    if (type.isGroup) return null;
    if (avatar != null && avatar!.isNotEmpty) return avatar;
    return participant?.avatar;
  }

  String typeLabel() {
    switch (type) {
      case ConversationType.dm:
        return 'Direct Message';
      case ConversationType.group:
        return 'Group';
      case ConversationType.unknown:
        return 'Conversation';
    }
  }
}

class GroupMember {
  final String memberId;
  final String userId;
  final String name;
  final String? username;
  final String? avatar;
  final String role;
  final bool isMe;

  const GroupMember({
    required this.memberId,
    required this.userId,
    required this.name,
    this.username,
    this.avatar,
    this.role = 'MEMBER',
    this.isMe = false,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      memberId: json['member_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      username: json['username']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString().toUpperCase() ?? 'MEMBER',
      isMe: json['is_me'] == true,
    );
  }

  bool get isAdmin => role == 'ADMIN';
}

class GroupMembersResponse {
  final List<GroupMember> members;
  final int total;

  const GroupMembersResponse({this.members = const [], this.total = 0});

  factory GroupMembersResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final meta = json['meta_data'];
    return GroupMembersResponse(
      members: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => GroupMember.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      total: meta is Map ? _asInt(meta['total']) : 0,
    );
  }

  int get adminCount =>
      members.where((m) => m.isAdmin).length;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
