class Register {
  final bool success;
  final String message;

  Register({
    required this.success,
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Register &&
        other.success == success &&
        other.message == message;
  }

  @override
  int get hashCode {
    return success.hashCode ^ message.hashCode;
  }

  @override
  String toString() {
    return 'Register(success: $success, message: $message)';
  }
}