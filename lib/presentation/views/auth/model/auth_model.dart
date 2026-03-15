class AuthModel {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isPageLoading;


  AuthModel({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isPageLoading = true,

  });

  AuthModel copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isPageLoading,

  }) {
    return AuthModel(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isPageLoading: isPageLoading ?? this.isPageLoading,

    );
  }
}
