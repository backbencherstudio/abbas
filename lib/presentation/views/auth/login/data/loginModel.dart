class LoginModel {
  bool? success;
  String? message;
  Authorization? authorization;
  String? type;

  LoginModel({this.success, this.message, this.authorization, this.type});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    authorization = json['authorization'] != null
        ? new Authorization.fromJson(json['authorization'])
        : null;
    type = json['type'];
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

  Authorization.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    return data;
  }
}
