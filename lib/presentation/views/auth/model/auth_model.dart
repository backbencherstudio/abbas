class AuthModel {
  final bool isLoading;
  final bool isPasswordVisible;

  AuthModel({this.isLoading = false, this.isPasswordVisible = false});

  AuthModel copyWith({bool? isLoading, bool? isPasswordVisible}) {
    return AuthModel(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
