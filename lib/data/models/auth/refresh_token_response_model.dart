import '../../../domain/entities/auth/refresh_token_response.dart';

class RefreshTokenResponseModel extends RefreshTokenResponse {
  RefreshTokenResponseModel({
    super.success,
    AuthorizationModel? super.authorization,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      success: json['success'],
      authorization: json['authorization'] != null
          ? AuthorizationModel.fromJson(json['authorization'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    if (this.authorization != null) {
      data['authorization'] = (this.authorization as AuthorizationModel).toJson();
    }
    return data;
  }
}

class AuthorizationModel extends Authorization {
  AuthorizationModel({
    super.type,
    super.accessToken,
  });

  factory AuthorizationModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationModel(
      type: json['type'],
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = this.type;
    data['access_token'] = this.accessToken;
    return data;
  }
}
