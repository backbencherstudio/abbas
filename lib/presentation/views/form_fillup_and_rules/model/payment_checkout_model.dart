class PaymentCheckoutModel {
  final bool success;
  final String message;
  final String? sessionUrl;

  PaymentCheckoutModel({
    required this.success,
    this.message = '',
    this.sessionUrl,
  });

  factory PaymentCheckoutModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return PaymentCheckoutModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      sessionUrl: data is Map ? data['session_url']?.toString() : null,
    );
  }
}
