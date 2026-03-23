class AllConversationModel {
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
  List<Memberships> memberships;
  List<Message> messages;
  Creator? creator;
  Participant? participant;
  int unread;
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
    List<Memberships>? memberships,
    List<Message>? messages,
    this.creator,
    this.participant,
    int? unread,
    this.otherUserAvatar,
  }) : memberships = memberships ?? [],
       messages = messages ?? [],
       unread = unread ?? 0;

  factory AllConversationModel.fromJson(Map<String, dynamic> json) {
    return AllConversationModel(
      id: json['id']?.toString(),
      creatorId: json['creator_id']?.toString(),
      participantId: json['participant_id']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      createdAt: json['createdAt']?.toString(),
      createdBy: json['createdBy']?.toString(),
      dmKey: json['dmKey']?.toString(),
      title: json['title']?.toString(),
      type: json['type']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      receiverTitle: json['receiverTitle']?.toString(),
      senderTitle: json['senderTitle']?.toString(),
      memberships:
          (json['memberships'] as List<dynamic>?)
              ?.map((e) => Memberships.fromJson(e))
              .toList() ??
          [],
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e))
              .toList() ??
          [],
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : null,
      participant: json['participant'] != null
          ? Participant.fromJson(json['participant'])
          : null,
      unread: json['unread'] ?? 0,
      otherUserAvatar: json['otherUserAvatar']?.toString(),
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
      'memberships': memberships.map((e) => e.toJson()).toList(),
      'messages': messages.map((e) => e.toJson()).toList(),
      'creator': creator,
      'participant': participant,
      'unread': unread,
      'otherUserAvatar': otherUserAvatar,
    };
  }
}

class Memberships {
  String? userId;
  String? role;
  String? lastReadAt;
  String? clearedAt;

  Memberships({this.userId, this.role, this.lastReadAt, this.clearedAt});

  factory Memberships.fromJson(Map<String, dynamic> json) {
    return Memberships(
      userId: json['userId']?.toString(),
      role: json['role']?.toString(),
      lastReadAt: json['lastReadAt']?.toString(),
      clearedAt: json['clearedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'role': role,
      'lastReadAt': lastReadAt,
      'clearedAt': clearedAt,
    };
  }
}

class Message {
  String? id;
  String? senderId;
  String? text;
  String? createdAt;

  Message({this.id, this.senderId, this.text, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString(),
      senderId: json['senderId']?.toString(),
      text: json['text']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'createdAt': createdAt,
    };
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['avatar'] = avatar;
    return data;
  }
}

class Participant {
  String? id;
  dynamic avatar;

  Participant({this.id, this.avatar});

  Participant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['avatar'] = avatar;
    return data;
  }
}
