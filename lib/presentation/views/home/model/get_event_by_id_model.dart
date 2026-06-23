class GetEventsByIdModel {
  bool? success;
  String? message;
  EventDetailsData? data;

  GetEventsByIdModel({this.success, this.message, this.data});

  GetEventsByIdModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] == true;
    message = json['message']?.toString();
    data = json['data'] is Map
        ? EventDetailsData.fromJson(
            Map<String, dynamic>.from(json['data'] as Map),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class EventDetailsData {
  String? id;
  String? name;
  String? description;
  String? overview;
  String? location;
  String? startAt;
  String? time;
  int? amountPence;
  num? fee;
  bool? isRegistered;
  String? status;

  EventDetailsData({
    this.id,
    this.name,
    this.description,
    this.overview,
    this.location,
    this.startAt,
    this.time,
    this.amountPence,
    this.fee,
    this.isRegistered,
    this.status,
  });

  EventDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    overview = json['overview']?.toString();
    location = json['location']?.toString();
    startAt = json['start_at']?.toString();
    time = json['time']?.toString();
    amountPence = json['amount_pence'] is int
        ? json['amount_pence'] as int
        : int.tryParse(json['amount_pence']?.toString() ?? '');
    fee = json['fee'] is num
        ? json['fee'] as num
        : num.tryParse(json['fee']?.toString() ?? '');
    isRegistered = json['is_registered'] == true;
    status = json['status']?.toString();
  }

  String get displayFee {
    if (fee != null) return fee!.toString();
    if (amountPence != null) return (amountPence! / 100).toString();
    return 'N/A';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'overview': overview,
      'location': location,
      'start_at': startAt,
      'time': time,
      'amount_pence': amountPence,
      'fee': fee,
      'is_registered': isRegistered,
      'status': status,
    };
  }
}
