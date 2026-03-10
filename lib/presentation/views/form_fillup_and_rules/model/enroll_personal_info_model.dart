class EnrollPersonalInfoModel {
  bool? success;
  String? message;
  Enrollment? enrollment;

  EnrollPersonalInfoModel({this.success, this.message, this.enrollment});

  EnrollPersonalInfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    enrollment = json['enrollment'] != null
        ? Enrollment.fromJson(json['enrollment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (enrollment != null) {
      data['enrollment'] = enrollment!.toJson();
    }
    return data;
  }
}

class Enrollment {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? dateOfBirth;
  String? experienceLevel;
  String? courseId;
  dynamic enrolledDocuments;
  String? status;
  bool? isPaymentCompleted;
  String? step;

  Enrollment(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.fullName,
        this.email,
        this.phone,
        this.address,
        this.dateOfBirth,
        this.experienceLevel,
        this.courseId,
        this.enrolledDocuments,
        this.status,
        this.isPaymentCompleted,
        this.step});

  Enrollment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    dateOfBirth = json['date_of_birth'];
    experienceLevel = json['experience_level'];
    courseId = json['courseId'];
    enrolledDocuments = json['enrolled_documents'];
    status = json['status'];
    isPaymentCompleted = json['IsPaymentCompleted'];
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['date_of_birth'] = this.dateOfBirth;
    data['experience_level'] = this.experienceLevel;
    data['courseId'] = this.courseId;
    data['enrolled_documents'] = this.enrolledDocuments;
    data['status'] = this.status;
    data['IsPaymentCompleted'] = this.isPaymentCompleted;
    data['step'] = this.step;
    return data;
  }
}
