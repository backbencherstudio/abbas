class CurrentStepModel {
  bool? success;
  String? message;
  Data? data;

  CurrentStepModel({this.success, this.message, this.data});

  CurrentStepModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class Data {
  String? enrollmentId;
  String? currentStep;

  Data({this.enrollmentId, this.currentStep});

  Data.fromJson(Map<String, dynamic> json) {
    enrollmentId = json['enrollment_id']?.toString();
    currentStep = json['current_step']?.toString() ?? json['step']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'enrollment_id': enrollmentId,
      'current_step': currentStep,
    };
  }
}
