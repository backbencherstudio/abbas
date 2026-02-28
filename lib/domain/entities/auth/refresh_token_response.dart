class RefreshTokenResponse {
  final bool? success;
  final Authorization? authorization;

  RefreshTokenResponse({this.success, this.authorization});
}

class Authorization {
  final String? type;
  final String? accessToken;

  Authorization({this.type, this.accessToken});
}
