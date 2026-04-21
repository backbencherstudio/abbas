class DmAllMessageModel {
  List<Items>? items;
  String? nextCursor;

  DmAllMessageModel({this.items, this.nextCursor});

  factory DmAllMessageModel.fromJson(Map<String, dynamic> json) {
    return DmAllMessageModel(
      items: (json['items'] as List?)
          ?.map((e) => Items.fromJson(Map<String, dynamic>.from(e)))
          .toList() ??
          [],
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
  String? conversationId;
  String? senderId;
  String? receiverId;
  String? kind;
  Content? content;
  String? mediaUrl;
  String? createdAt;
  String? deletedAt;
  String? deletedById;
  String? readAt;
  Sender? sender;
  String? status;

  Items({
    this.id,
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.kind,
    this.content,
    this.mediaUrl,
    this.createdAt,
    this.deletedAt,
    this.deletedById,
    this.readAt,
    this.sender,
    this.status,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json['id']?.toString(),
      conversationId: json['conversationId']?.toString(),
      senderId: json['senderId']?.toString(),
      receiverId: json['receiver_id']?.toString() ?? json['receiverId']?.toString(),
      kind: json['kind']?.toString(),
      content: json['content'] is Map<String, dynamic>
          ? Content.fromJson(Map<String, dynamic>.from(json['content']))
          : null,
      mediaUrl: json['media_Url']?.toString() ?? json['mediaUrl']?.toString(),
      createdAt: json['createdAt']?.toString(),
      deletedAt: json['deletedAt']?.toString(),
      deletedById: json['deletedById']?.toString(),
      readAt: json['readAt']?.toString(),
      sender: json['sender'] is Map<String, dynamic>
          ? Sender.fromJson(Map<String, dynamic>.from(json['sender']))
          : null,
      status: json['status']?.toString() ?? 'sent',
    );
  }

  factory Items.fromSocket(Map<String, dynamic> raw) {
    Map<String, dynamic> json = raw;

    if (raw['data'] is Map<String, dynamic>) {
      json = Map<String, dynamic>.from(raw['data']);
    }

    return Items(
      id: json['id']?.toString(),
      conversationId: json['conversationId']?.toString(),
      senderId: json['senderId']?.toString(),
      receiverId: json['receiver_id']?.toString() ?? json['receiverId']?.toString(),
      kind: json['kind']?.toString() ?? 'TEXT',
      content: json['content'] is Map<String, dynamic>
          ? Content.fromJson(Map<String, dynamic>.from(json['content']))
          : null,
      mediaUrl: json['media_Url']?.toString() ?? json['mediaUrl']?.toString(),
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      deletedAt: json['deletedAt']?.toString(),
      deletedById: json['deletedById']?.toString(),
      readAt: json['readAt']?.toString(),
      sender: json['sender'] is Map<String, dynamic>
          ? Sender.fromJson(Map<String, dynamic>.from(json['sender']))
          : null,
      status: json['status']?.toString() ?? 'sent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiver_id': receiverId,
      'kind': kind,
      'content': content?.toJson(),
      'media_Url': mediaUrl,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
      'deletedById': deletedById,
      'readAt': readAt,
      'sender': sender?.toJson(),
      'status': status,
    };
  }
}

class Content {
  String? text;
  String? fileName;
  int? size;
  String? mimeType;

  Content({
    this.text,
    this.fileName,
    this.size,
    this.mimeType,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      text: json['text']?.toString(),
      fileName: json['fileName']?.toString(),
      size: json['size'] is int ? json['size'] as int : int.tryParse('${json['size']}'),
      mimeType: json['mimeType']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'fileName': fileName,
      'size': size,
      'mimeType': mimeType,
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
