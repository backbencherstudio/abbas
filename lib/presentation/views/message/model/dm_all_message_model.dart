class DmAllMessageModel {
  List<Items> items;
  String nextCursor;

  DmAllMessageModel({
    required this.items,
    required this.nextCursor,
  });

  factory DmAllMessageModel.fromJson(Map<String, dynamic> json) {
    return DmAllMessageModel(
      items: List<Items>.from(json['items'].map((v) => Items.fromJson(v))),
      nextCursor: json['nextCursor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((v) => v.toJson()).toList(),
      'nextCursor': nextCursor,
    };
  }
}

class Items {
  String id;
  String receiverId;
  Content content;
  String conversationId;
  String createdAt;
  String deletedAt;
  String deletedById;
  String kind;
  String senderId;
  String senderUserId;
  String readAt;
  String mediaUrl;
  Sender sender;

  Items({
    required this.id,
    required this.receiverId,
    required this.content,
    required this.conversationId,
    required this.createdAt,
    required this.deletedAt,
    required this.deletedById,
    required this.kind,
    required this.senderId,
    required this.senderUserId,
    required this.readAt,
    required this.mediaUrl,
    required this.sender,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json['id'],
      receiverId: json['receiver_id'],
      content: Content.fromJson(json['content']),
      conversationId: json['conversationId'],
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
      deletedById: json['deletedById'],
      kind: json['kind'],
      senderId: json['senderId'],
      senderUserId: json['sender_user_id'],
      readAt: json['readAt'],
      mediaUrl: json['media_Url'],
      sender: Sender.fromJson(json['sender']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiver_id': receiverId,
      'content': content.toJson(),
      'conversationId': conversationId,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
      'deletedById': deletedById,
      'kind': kind,
      'senderId': senderId,
      'sender_user_id': senderUserId,
      'readAt': readAt,
      'media_Url': mediaUrl,
      'sender': sender.toJson(),
    };
  }
}

class Content {
  String text;

  Content({
    required this.text,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

class Sender {
  String id;
  String name;
  String avatar;

  Sender({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
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