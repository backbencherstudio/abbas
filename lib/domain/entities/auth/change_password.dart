class ChangePasswordEntity {
  final bool success;
  final String message;

  ChangePasswordEntity({
    required this.success,
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChangePasswordEntity && other.success == success && other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;

  @override
  String toString() => 'ChangePasswordEntity(success: $success, message: $message)';
}