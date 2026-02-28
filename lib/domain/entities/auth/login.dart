class Login {
  final bool? success;
  final String? message;
  final LoginAuthorization? authorization;
  final String? type;

  Login({
    this.success,
    this.message,
    this.authorization,
    this.type,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Login &&
        other.success == success &&
        other.message == message &&
        other.authorization == authorization &&
        other.type == type;
  }

  @override
  int get hashCode {
    return success.hashCode ^
    message.hashCode ^
    authorization.hashCode ^
    type.hashCode;
  }

  @override
  String toString() {
    return 'Login(success: $success, message: $message, authorization: $authorization, type: $type)';
  }
}

class LoginAuthorization {
  final String? type;
  final String? accessToken;
  final String? refreshToken;

  LoginAuthorization({
    this.type,
    this.accessToken,
    this.refreshToken,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginAuthorization &&
        other.type == type &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return type.hashCode ^ accessToken.hashCode ^ refreshToken.hashCode;
  }

  @override
  String toString() {
    return 'LoginAuthorization(type: $type, accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}