class AllConversationModel {
  String? id;
  String? creatorId;
  String? participantId;
  String? avatarUrl;
  String? createdAt;
  String? createdBy;
  String? dmKey;
  String? title; // Changed from Null? to String?
  String? type;
  String? updatedAt;
  String? receiverTitle;
  String? senderTitle;
  List<Memberships>? memberships;
  List<Messages>? messages; // Correct type
  Creator? creator;
  Creator? participant;
  int? unread;
  String? otherUserAvatar;

  AllConversationModel({
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
    this.messages,
    this.creator,
    this.participant,
    this.unread,
    this.otherUserAvatar,
  });

  AllConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    participantId = json['participant_id'];
    avatarUrl = json['avatarUrl'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    dmKey = json['dmKey'];
    title = json['title']; // Safe
    type = json['type'];
    updatedAt = json['updatedAt'];
    receiverTitle = json['receiverTitle'];
    senderTitle = json['senderTitle'];

    // Memberships
    if (json['memberships'] != null) {
      memberships = <Memberships>[];
      json['memberships'].forEach((v) {
        memberships!.add(Memberships.fromJson(v));
      });
    }

    // Messages - Most Important Fix
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }

    // Creator & Participant
    creator = json['creator'] != null
        ? Creator.fromJson(json['creator'])
        : null;
    participant = json['participant'] != null
        ? Creator.fromJson(json['participant'])
        : null;

    unread = json['unread'];
    otherUserAvatar = json['otherUserAvatar'];
  }

  // Optional: toJson() if needed
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['creator_id'] = creatorId;
    data['participant_id'] = participantId;
    data['avatarUrl'] = avatarUrl;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['dmKey'] = dmKey;
    data['title'] = title;
    data['type'] = type;
    data['updatedAt'] = updatedAt;
    data['receiverTitle'] = receiverTitle;
    data['senderTitle'] = senderTitle;

    if (memberships != null) {
      data['memberships'] = memberships!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    if (participant != null) {
      data['participant'] = participant!.toJson();
    }
    data['unread'] = unread;
    data['otherUserAvatar'] = otherUserAvatar;

    return data;
  }
}

// ================== Other Models (Unchanged but Cleaned) ==================

class Memberships {
  String? userId;
  String? role;
  String? lastReadAt;
  String? clearedAt; // Changed from Null? to String?

  Memberships({this.userId, this.role, this.lastReadAt, this.clearedAt});

  Memberships.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    role = json['role'];
    lastReadAt = json['lastReadAt'];
    clearedAt = json['clearedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['role'] = role;
    data['lastReadAt'] = lastReadAt;
    data['clearedAt'] = clearedAt;
    return data;
  }
}

class Messages {
  String? id;
  String? receiverId; // Changed from Null? to String?
  Content? content;
  String? conversationId;
  String? createdAt;
  String? deletedAt; // Changed from Null?
  String? deletedById; // Changed from Null?
  String? kind;
  String? senderId;
  String? senderUserId; // Changed from Null?
  String? readAt; // Changed from Null?
  String? mediaUrl; // Changed from Null? to String?

  Messages({
    this.id,
    this.receiverId,
    this.content,
    this.conversationId,
    this.createdAt,
    this.deletedAt,
    this.deletedById,
    this.kind,
    this.senderId,
    this.senderUserId,
    this.readAt,
    this.mediaUrl,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverId = json['receiver_id'];
    content = json['content'] != null
        ? Content.fromJson(json['content'])
        : null;
    conversationId = json['conversationId'];
    createdAt = json['createdAt'];
    deletedAt = json['deletedAt'];
    deletedById = json['deletedById'];
    kind = json['kind'];
    senderId = json['senderId'];
    senderUserId = json['sender_user_id'];
    readAt = json['readAt'];
    mediaUrl = json['media_Url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['receiver_id'] = receiverId;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    data['conversationId'] = conversationId;
    data['createdAt'] = createdAt;
    data['deletedAt'] = deletedAt;
    data['deletedById'] = deletedById;
    data['kind'] = kind;
    data['senderId'] = senderId;
    data['sender_user_id'] = senderUserId;
    data['readAt'] = readAt;
    data['media_Url'] = mediaUrl;
    return data;
  }
}

class Content {
  String? text;

  Content({this.text});

  Content.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    return data;
  }
}

class Creator {
  String? id;
  String? avatar;

  Creator({this.id, this.avatar});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    return data;
  }
}
