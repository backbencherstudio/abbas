class LoginResponseModel {
  bool? success;
  dynamic message;
  Authorization? authorization;
  String? type;

  LoginResponseModel({this.success, this.message, this.authorization, this.type});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      message: json['message'],
      authorization: json['authorization'] != null
          ? Authorization.fromJson(json['authorization'])
          : null,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.authorization != null) {
      data['authorization'] = this.authorization!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Authorization {
  String? type;
  String? accessToken;
  String? refreshToken;

  Authorization({this.type, this.accessToken, this.refreshToken});

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      type: json['type'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    return data;
  }
}