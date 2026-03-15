class CurrentStepModel {
  bool? success;
  Data? data;

  CurrentStepModel({this.success, this.data});

  CurrentStepModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? enrollmentId;
  String? step;

  Data({this.enrollmentId, this.step});

  Data.fromJson(Map<String, dynamic> json) {
    enrollmentId = json['enrollment_id'];
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['enrollment_id'] = enrollmentId;
    data['step'] = step;
    return data;
  }
}
