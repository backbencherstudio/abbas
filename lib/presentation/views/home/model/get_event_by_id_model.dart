class GetEventsByIdModel {
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

  GetEventsByIdModel(
      {this.id,
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
        this.createdBy});

  GetEventsByIdModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
