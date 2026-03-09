class PostEnrollPersonalInfoModel {
  bool? success;
  String? message;
  Data? data;

  PostEnrollPersonalInfoModel({this.success, this.message, this.data});

  PostEnrollPersonalInfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['date_of_birth'] = dateOfBirth;
    data['experience_level'] = experienceLevel;
    data['courseId'] = courseId;
    data['enrolled_documents'] = enrolledDocuments;
    data['status'] = status;
    data['IsPaymentCompleted'] = isPaymentCompleted;
    data['step'] = step;
    return data;
  }
}
