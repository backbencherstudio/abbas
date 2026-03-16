class DmAllMessageModel {
  List<Items>? items;
  String? nextCursor;

  DmAllMessageModel({
    this.items,
    this.nextCursor,
  });

  factory DmAllMessageModel.fromJson(Map<String, dynamic> json) {
    return DmAllMessageModel(
      items: (json['items'] as List?)
          ?.map((e) => Items.fromJson(e))
          .toList(),
      nextCursor: json['nextCursor']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toJson()).toList(),
      'nextCursor': nextCursor,
    };
  }
}

class Items {
  String? id;
  String? receiverId;
  Content? content;
  String? conversationId;
  String? createdAt;
  String? deletedAt;
  String? deletedById;
  String? kind;
  String? senderId;
  String? senderUserId;
  String? readAt;
  String? mediaUrl;
  Sender? sender;

  Items({
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
    this.sender,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json['id']?.toString(),
      receiverId: json['receiver_id']?.toString(),
      content:
      json['content'] != null ? Content.fromJson(json['content']) : null,
      conversationId: json['conversationId']?.toString(),
      createdAt: json['createdAt']?.toString(),
      deletedAt: json['deletedAt']?.toString(),
      deletedById: json['deletedById']?.toString(),
      kind: json['kind']?.toString(),
      senderId: json['senderId']?.toString(),
      senderUserId: json['sender_user_id']?.toString(),
      readAt: json['readAt']?.toString(),
      mediaUrl: json['media_Url']?.toString(),
      sender:
      json['sender'] != null ? Sender.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiver_id': receiverId,
      'content': content?.toJson(),
      'conversationId': conversationId,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
      'deletedById': deletedById,
      'kind': kind,
      'senderId': senderId,
      'sender_user_id': senderUserId,
      'readAt': readAt,
      'media_Url': mediaUrl,
      'sender': sender?.toJson(),
    };
  }
}

class Content {
  String? text;

  Content({this.text});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      text: json['text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

class Sender {
  String? id;
  String? name;
  String? avatar;

  Sender({
    this.id,
    this.name,
    this.avatar,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }
}