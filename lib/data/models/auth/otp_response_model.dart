class OTPResponseModel {
  final bool success;
  final String message;

  OTPResponseModel({
    required this.success,
    required this.message,
  });

  factory OTPResponseModel.fromJson(Map<String, dynamic> json) {
    return OTPResponseModel(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}