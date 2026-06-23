class GetAllEventsModel {
  String? id;
  String? name;
  String? description;
  String? location;
  String? startAt;
  String? time;
  bool? isRegistered;
  String? status;

  GetAllEventsModel({
    this.id,
    this.name,
    this.description,
    this.location,
    this.startAt,
    this.time,
    this.isRegistered,
    this.status,
  });

  GetAllEventsModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    location = json['location']?.toString();
    startAt = json['start_at']?.toString();
    time = json['time']?.toString();
    isRegistered = json['is_registered'] == true;
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'start_at': startAt,
      'time': time,
      'is_registered': isRegistered,
      'status': status,
    };
  }
}
