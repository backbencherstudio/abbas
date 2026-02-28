class OTPEntity {
  final bool success;
  final String message;

  OTPEntity({
    required this.success,
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OTPEntity && other.success == success && other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;

  @override
  String toString() => 'OTPEntity(success: $success, message: $message)';
}