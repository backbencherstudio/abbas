class GetEventsByIdModel {
  bool? success;
  String? message;
  Data? data;

  GetEventsByIdModel({this.success, this.message, this.data});

  GetEventsByIdModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? name;
  String? description;
  dynamic overview;
  String? date;
  String? time;
  String? location;
  String? amount;
  String? createdBy;
  List<Members>? members;
  Creator? creator;
  int? registeredMembersCount;

  Data({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.description,
    this.overview,
    this.date,
    this.time,
    this.location,
    this.amount,
    this.createdBy,
    this.members,
    this.creator,
    this.registeredMembersCount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    name = json['name'];
    description = json['description'];
    overview = json['overview'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    amount = json['amount'];
    createdBy = json['created_by'];
    members = (json['members'] as List)
        .map((e) => Members.fromJson(e))
        .toList();

    creator = json['creator'] != null
        ? Creator.fromJson(json['creator'])
        : null;
    registeredMembersCount = json['registeredMembersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['name'] = name;
    data['description'] = description;
    data['overview'] = overview;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    data['amount'] = amount;
    data['created_by'] = createdBy;
    data['members'] = members?.map((e) => e.toJson()).toList();
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    data['registeredMembersCount'] = registeredMembersCount;
    return data;
  }
}

class Members {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? ticketNumber;
  String? eventId;
  String? userId;
  String? paymentId;
  User? user;

  Members({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.ticketNumber,
    this.eventId,
    this.userId,
    this.paymentId,
    this.user,
  });

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ticketNumber = json['ticket_number'];
    eventId = json['event_id'];
    userId = json['user_id'];
    paymentId = json['payment_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['ticket_number'] = ticketNumber;
    data['event_id'] = eventId;
    data['user_id'] = userId;
    data['payment_id'] = paymentId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? avatar;

  User({this.id, this.name, this.email, this.phoneNumber, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['avatar'] = avatar;
    return data;
  }
}

class Creator {
  String? id;
  String? name;
  String? email;
  String? avatar;

  Creator({this.id, this.name, this.email, this.avatar});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    return data;
  }
}
