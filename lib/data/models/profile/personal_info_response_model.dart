// data/models/profile/personal_info_response_model.dart
class PersonalInfoResponseModel {
  final bool success;
  final Map<String, dynamic> data;

  PersonalInfoResponseModel({
    required this.success,
    required this.data,
  });

  factory PersonalInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoResponseModel(
      success: json['success'] ?? false,
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
    };
  }
}