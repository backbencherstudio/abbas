class CreateConversationModel {
  String id;
  String creatorId;
  String participantId;
  String avatarUrl;
  String createdAt;
  String createdBy;
  String dmKey;
  String title;
  String type;
  String updatedAt;
  String receiverTitle;
  String senderTitle;
  List<Membership> memberships;

  CreateConversationModel({
    required this.id,
    required this.creatorId,
    required this.participantId,
    this.avatarUrl = '',
    required this.createdAt,
    required this.createdBy,
    this.dmKey = '',
    this.title = '',
    this.type = '',
    required this.updatedAt,
    this.receiverTitle = '',
    this.senderTitle = '',
    List<Membership>? memberships,
  }) : memberships = memberships ?? [];

  factory CreateConversationModel.fromJson(Map<String, dynamic> json) {
    return CreateConversationModel(
      id: json['id'] ?? '',
      creatorId: json['creator_id'] ?? '',
      participantId: json['participant_id'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      dmKey: json['dmKey'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      receiverTitle: json['receiverTitle'] ?? '',
      senderTitle: json['senderTitle'] ?? '',
      memberships: json['memberships'] != null
          ? List<Membership>.from(
              json['memberships'].map((x) => Membership.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'participant_id': participantId,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'dmKey': dmKey,
      'title': title,
      'type': type,
      'updatedAt': updatedAt,
      'receiverTitle': receiverTitle,
      'senderTitle': senderTitle,
      'memberships': memberships.map((x) => x.toJson()).toList(),
    };
  }
}

class Membership {
  String id;
  String role;
  String joinedAt;
  String lastReadAt;
  String clearedAt;
  String mutedUntil;
  String archivedAt;
  String leftAt;
  String userId;
  String conversationId;

  Membership({
    required this.id,
    required this.role,
    required this.joinedAt,
    required this.lastReadAt,
    this.clearedAt = '',
    this.mutedUntil = '',
    this.archivedAt = '',
    this.leftAt = '',
    required this.userId,
    required this.conversationId,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      joinedAt: json['joinedAt'] ?? '',
      lastReadAt: json['lastReadAt'] ?? '',
      clearedAt: json['clearedAt'] ?? '',
      mutedUntil: json['mutedUntil'] ?? '',
      archivedAt: json['archivedAt'] ?? '',
      leftAt: json['leftAt'] ?? '',
      userId: json['userId'] ?? '',
      conversationId: json['conversationId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'joinedAt': joinedAt,
      'lastReadAt': lastReadAt,
      'clearedAt': clearedAt,
      'mutedUntil': mutedUntil,
      'archivedAt': archivedAt,
      'leftAt': leftAt,
      'userId': userId,
      'conversationId': conversationId,
    };
  }
}
