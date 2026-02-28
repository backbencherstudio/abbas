class SetNewPasswordEntity {
  final bool success;
  final String message;

  SetNewPasswordEntity({
    required this.success,
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SetNewPasswordEntity && other.success == success && other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;

  @override
  String toString() => 'SetPasswordEntity(success: $success, message: $message)';
}