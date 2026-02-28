class EditPersonalInfoResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? userData;

  EditPersonalInfoResponseModel({
    required this.success,
    required this.message,
    this.userData,
  });

  factory EditPersonalInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return EditPersonalInfoResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      userData: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': userData};
  }
}


