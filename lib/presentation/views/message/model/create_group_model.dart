class CreateGroupModel {
  String? id;
  String? creatorId;
  String? participantId;
  String? avatarUrl;
  String? createdAt;
  String? createdBy;
  String? dmKey;
  String? title;
  String? type;
  String? updatedAt;
  String? receiverTitle;
  String? senderTitle;
  List<Memberships>? memberships;

  CreateGroupModel({
    this.id,
    this.creatorId,
    this.participantId,
    this.avatarUrl,
    this.createdAt,
    this.createdBy,
    this.dmKey,
    this.title,
    this.type,
    this.updatedAt,
    this.receiverTitle,
    this.senderTitle,
    this.memberships,
  });

  factory CreateGroupModel.fromJson(Map<String, dynamic> json) {
    return CreateGroupModel(
      id: json['id'] as String?,
      creatorId: json['creator_id'] as String?,
      participantId: json['participant_id'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      createdBy: json['createdBy'] as String?,
      dmKey: json['dmKey'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      updatedAt: json['updatedAt'] as String?,
      receiverTitle: json['receiverTitle'] as String?,
      senderTitle: json['senderTitle'] as String?,
      memberships: (json['memberships'] as List<dynamic>?)
          ?.map((v) => Memberships.fromJson(v as Map<String, dynamic>))
          .toList(),
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
      if (memberships != null)
        'memberships': memberships!.map((v) => v.toJson()).toList(),
    };
  }
}

class Memberships {
  String? id;
  String? role;
  String? joinedAt;
  String? lastReadAt;
  String? clearedAt;
  String? mutedUntil;
  String? archivedAt;
  String? leftAt;
  String? userId;
  String? conversationId;

  Memberships({
    this.id,
    this.role,
    this.joinedAt,
    this.lastReadAt,
    this.clearedAt,
    this.mutedUntil,
    this.archivedAt,
    this.leftAt,
    this.userId,
    this.conversationId,
  });

  factory Memberships.fromJson(Map<String, dynamic> json) {
    return Memberships(
      id: json['id'] as String?,
      role: json['role'] as String?,
      joinedAt: json['joinedAt'] as String?,
      lastReadAt: json['lastReadAt'] as String?,
      clearedAt: json['clearedAt'] as String?,
      mutedUntil: json['mutedUntil'] as String?,
      archivedAt: json['archivedAt'] as String?,
      leftAt: json['leftAt'] as String?,
      userId: json['userId'] as String?,
      conversationId: json['conversationId'] as String?,
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